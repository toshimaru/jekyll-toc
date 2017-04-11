module Jekyll
  module TableOfContents
    class Parser
      PUNCTUATION_REGEXP = /[^\p{Word}\- ]/u

      attr_reader :doc

      def initialize(html)
        @doc = Nokogiri::HTML::DocumentFragment.parse(html)
        @entries = parse_content
      end

      def build_toc
        toc = %(<ul class="section-nav">\n)

        min_h_num = 6
        @entries.each do |entry|
          h_num = entry[:node_name].delete('h').to_i
          min_h_num = [min_h_num, h_num].min
        end
        toc << build_lis(@entries, min_h_num)

        toc << '</ul>'
      end

      # Returns the list items for entries
      def build_lis(entries, min_h_num)
        lis = ''
        i = 0
        while i < entries.length do
          entry = entries[i]
          curr_h_num = entry[:node_name].delete('h').to_i
          if curr_h_num == min_h_num
            # If the current entry should not be indented in the list, add the entry to the list
            lis << %(<li class="toc-entry toc-#{entry[:node_name]}"><a href="##{entry[:id]}#{entry[:uniq]}">#{entry[:text]}</a>)
            # If the next entry should be indented in the list, generate a sublist
            if i + 1 < entries.length
              next_entry = entries[i + 1]
              next_h_num = next_entry[:node_name].delete('h').to_i
              if next_h_num > min_h_num
                lis << %(\n)
                lis << %(<ul>\n)
                nest_entries = get_nest_entries(entries[i + 1, entries.length], min_h_num)
                lis << build_lis(nest_entries, min_h_num + 1)
                lis << %(</ul>\n)
                i += nest_entries.length
              end
            end
            # Add the closing tag for the current entry in the list
            lis << %(</li>\n)
          elsif curr_h_num > min_h_num
            # If the current entry should be indented in the list, generate a sublist
            lis << %(<ul>\n)
            nest_entries = get_nest_entries(entries[i, entries.length], min_h_num)
            lis << build_lis(nest_entries, min_h_num + 1)
            lis << %(</ul>\n)
            i += nest_entries.length - 1
          end
          i += 1
        end
        lis
      end

      # Returns the entries in a nested list
      # The nested list starts at the first entry in entries (inclusive)
      # The nested list ends at the first entry in entries with depth min_h_num or greater (exclusive)
      def get_nest_entries(entries, min_h_num)
        nest_entries = []
        (0..(entries.length - 1)).each do |i|
          nest_entry = entries[i]
          nest_h_num = nest_entry[:node_name].delete('h').to_i
          if nest_h_num > min_h_num
            nest_entries.push(nest_entry)
          else
            break
          end
        end
        nest_entries
      end

      def inject_anchors_into_html
        @entries.each do |entry|
          entry[:content_node].add_previous_sibling(%(<a id="#{entry[:id]}#{entry[:uniq]}" class="anchor" href="##{entry[:id]}#{entry[:uniq]}" aria-hidden="true"><span class="octicon octicon-link"></span></a>))
        end

        @doc.inner_html
      end

      def toc
        build_toc + inject_anchors_into_html
      end

      # parse logic is from html-pipeline toc_filter
      # https://github.com/jch/html-pipeline/blob/v1.1.0/lib/html/pipeline/toc_filter.rb
      private

      def parse_content
        entries = []
        headers = Hash.new(0)

        @doc.css('h1, h2, h3, h4, h5, h6').each do |node|
          text = node.text
          id = text.downcase
          id.gsub!(PUNCTUATION_REGEXP, '') # remove punctuation
          id.gsub!(' ', '-') # replace spaces with dash

          uniq = headers[id] > 0 ? "-#{headers[id]}" : ''
          headers[id] += 1
          next unless header_content == node.children.first

          entries << {
            id: id,
            uniq: uniq,
            text: text,
            node_name: node.name,
            content_node: header_content
          }
        end

        entries
      end
    end
  end
end
