module Jekyll
  module TableOfContents
    # Parse html contents and generate table of contents
    class Parser
      PUNCTUATION_REGEXP = /[^\p{Word}\- ]/u

      DEFAULT_CONFIG = {
        "min_level" => 1,
        "max_level" => 6,
        "list_class" => "section-nav",
        "sublist_class" => "",
        "item_class" => "toc-entry",
        "item_prefix" => "toc-"
      }

      def initialize(html, options = {})
        @doc = Nokogiri::HTML::DocumentFragment.parse(html)
        options = generate_option_hash(options)
        @toc_levels = options["min_level"]..options["max_level"]
        @list_class = options["list_class"]
        @sublist_class = options["sublist_class"]
        @item_class = options["item_class"]
        @item_prefix = options["item_prefix"]
        @entries = parse_content
      end

      def build_toc
        %(<ul class="#{@list_class}">\n#{build_toc_list(@entries, last_ul_used: true)}</ul>)
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

      private

      # parse logic is from html-pipeline toc_filter
      # https://github.com/jch/html-pipeline/blob/v1.1.0/lib/html/pipeline/toc_filter.rb
      def parse_content
        entries = []
        headers = Hash.new(0)

        # TODO: Use kramdown auto ids
        @doc.css(toc_headings).each do |node|
          text = node.text
          id = text.downcase
          id.gsub!(PUNCTUATION_REGEXP, '') # remove punctuation
          id.gsub!(' ', '-') # replace spaces with dash

          uniq = headers[id] > 0 ? "-#{headers[id]}" : ''
          headers[id] += 1
          header_content = node.children.first
          next unless header_content

          entries << {
            id: id,
            uniq: uniq,
            text: text,
            node_name: node.name,
            no_toc: node.attribute('class') && node.attribute('class').value.include?('no_toc'),
            content_node: header_content,
            h_num: node.name.delete('h').to_i
          }
        end

        entries
      end

      # Returns the list items for entries
      def build_toc_list(entries, last_ul_used: false)
        i = 0
        toc_list = ''
        min_h_num = entries.map { |e| e[:h_num] }.min

        while i < entries.count
          entry = entries[i]
          if entry[:no_toc]
            # Do nothing / skip entry
          elsif entry[:h_num] == min_h_num
            # If the current entry should not be indented in the list, add the entry to the list
            toc_list << %(<li class="#{@item_class} #{@item_prefix}#{entry[:node_name]}"><a href="##{entry[:id]}#{entry[:uniq]}">#{entry[:text]}</a>)
            # If the next entry should be indented in the list, generate a sublist
            if i + 1 < entries.count
              next_entry = entries[i + 1]
              if next_entry[:h_num] > min_h_num
                nest_entries = get_nest_entries(entries[i + 1, entries.count], min_h_num)
                ul_attributes = @sublist_class.empty? ? "" : %( class="#{@sublist_class}")
                toc_list << %(\n<ul#{ul_attributes}>\n#{build_toc_list(nest_entries, last_ul_used: true)}</ul>\n)
                i += nest_entries.count
              end
            end
            # Add the closing tag for the current entry in the list
            toc_list << %(</li>\n)
          elsif entry[:h_num] > min_h_num
            # If the current entry should be indented in the list, generate a sublist
            nest_entries = get_nest_entries(entries[i, entries.count], min_h_num)
            if last_ul_used
              toc_list << build_toc_list(nest_entries, last_ul_used: true)
            else
              ul_attributes = @sublist_class.empty? ? "" : %( class="#{@sublist_class}")
              toc_list << %(<ul#{ul_attributes}">\n#{build_toc_list(nest_entries, last_ul_used: true)}</ul>\n)
            end
            i += nest_entries.count - 1
          end
          i += 1
        end

        toc_list
      end

      # Returns the entries in a nested list
      # The nested list starts at the first entry in entries (inclusive)
      # The nested list ends at the first entry in entries with depth min_h_num or greater (exclusive)
      def get_nest_entries(entries, min_h_num)
        entries.inject([]) do |nest_entries, entry|
          break nest_entries if entry[:h_num] == min_h_num
          nest_entries << entry
        end
      end

      def toc_headings
        @toc_levels.map { |level| "h#{level}" }.join(",")
      end

      def generate_option_hash(options)
        DEFAULT_CONFIG.merge(options)
      rescue TypeError
        DEFAULT_CONFIG
      end
    end
  end
end
