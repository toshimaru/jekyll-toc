# frozen_string_literal: true

require 'table_of_contents/helper'

module Jekyll
  module TableOfContents
    # Parse html contents and generate table of contents
    class Parser
      include ::Jekyll::TableOfContents::Helper

      def initialize(html, options = {})
        @doc = Nokogiri::HTML::DocumentFragment.parse(html)
        @configuration = Configuration.new(options)
        @entries = parse_content
      end

      def toc
        build_toc + inject_anchors_into_html
      end

      def build_toc
        %(<#{list_tag} id="#{@configuration.list_id}" class="#{@configuration.list_class}">\n#{build_toc_list(@entries)}</#{list_tag}>)
      end

      def inject_anchors_into_html
        @entries.each do |entry|
          # NOTE: `entry[:id]` is automatically URL encoded by Nokogiri
          entry[:header_content].add_previous_sibling(
            %(<a class="anchor" href="##{entry[:id]}" aria-hidden="true"><span class="octicon octicon-link"></span></a>)
          )
        end

        @doc.inner_html
      end

      private

      # parse logic is from html-pipeline toc_filter
      # https://github.com/jch/html-pipeline/blob/v1.1.0/lib/html/pipeline/toc_filter.rb
      def parse_content
        headers = Hash.new(0)

        (@doc.css(toc_headings) - @doc.css(toc_headings_in_no_toc_section))
          .reject { |n| n.classes.include?(@configuration.no_toc_class) }
          .inject([]) do |entries, node|
          text = node.text
          id = node.attribute('id') || generate_toc_id(text)

          suffix_num = headers[id]
          headers[id] += 1

          entries << {
            id: suffix_num.zero? ? id : "#{id}-#{suffix_num}",
            text: CGI.escapeHTML(text),
            node_name: node.name,
            header_content: node.children.first,
            h_num: node.name.delete('h').to_i
          }
        end
      end

      # Returns the list items for entries
      def build_toc_list(entries)
        i = 0
        toc_list = +''
        min_h_num = entries.map { |e| e[:h_num] }.min

        while i < entries.count
          entry = entries[i]
          if entry[:h_num] == min_h_num
            # If the current entry should not be indented in the list, add the entry to the list
            toc_list << %(<li class="#{@configuration.item_class} #{@configuration.item_prefix}#{entry[:node_name]}"><a href="##{entry[:id]}">#{entry[:text]}</a>)
            # If the next entry should be indented in the list, generate a sublist
            next_i = i + 1
            if next_i < entries.count && entries[next_i][:h_num] > min_h_num
              nest_entries = get_nest_entries(entries[next_i, entries.count], min_h_num)
              toc_list << %(\n<#{list_tag}#{ul_attributes}>\n#{build_toc_list(nest_entries)}</#{list_tag}>\n)
              i += nest_entries.count
            end
            # Add the closing tag for the current entry in the list
            toc_list << %(</li>\n)
          elsif entry[:h_num] > min_h_num
            # If the current entry should be indented in the list, generate a sublist
            nest_entries = get_nest_entries(entries[i, entries.count], min_h_num)
            toc_list << build_toc_list(nest_entries)
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
        @configuration.toc_levels.map { |level| "h#{level}" }.join(',')
      end

      def toc_headings_in_no_toc_section
        if @configuration.no_toc_section_class.is_a?(Array)
          @configuration.no_toc_section_class.map { |cls| toc_headings_within(cls) }.join(',')
        else
          toc_headings_within(@configuration.no_toc_section_class)
        end
      end

      def toc_headings_within(class_name)
        @configuration.toc_levels.map { |level| ".#{class_name} h#{level}" }.join(',')
      end

      def ul_attributes
        @ul_attributes ||= @configuration.sublist_class.empty? ? '' : %( class="#{@configuration.sublist_class}")
      end

      def list_tag
        @list_tag ||= @configuration.ordered_list ? 'ol' : 'ul'
      end
    end
  end
end
