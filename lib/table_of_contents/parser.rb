module Jekyll
  module TableOfContents
    # Parse html contents and generate table of contents
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
        while i < entries.length
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
          break unless nest_h_num > min_h_num
          nest_entries.push(nest_entry)
        end
        nest_entries
      end
    end
  end
end
