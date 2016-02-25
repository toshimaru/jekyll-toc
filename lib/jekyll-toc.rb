require 'nokogiri'

module Jekyll
  module TableOfContents
    PUNCTUATION_REGEXP = RUBY_VERSION > '1.9' ? /[^\p{Word}\- ]/u : /[^\w\- ]/

    class Parser
      attr_reader :doc

      def initialize(html)
        @doc = Nokogiri::HTML::DocumentFragment.parse(html)
        @entries = parse_content
      end

      def build_toc
        toc = %Q{<ul class="section-nav">\n}

        @entries.each do |entry|
          toc << %Q{<li><a href="##{entry[:id]}#{entry[:uniq]}">#{entry[:text]}</a></li>\n}
        end

        toc << '</ul>'
      end

      def inject_anchors_into_html
        @entries.each do |entry|
          entry[:content_node].add_previous_sibling(%Q{<a id="#{entry[:id]}#{entry[:uniq]}" class="anchor" href="##{entry[:id]}#{entry[:uniq]}" aria-hidden="true"><span class="octicon octicon-link"></span></a>})
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

          uniq = (headers[id] > 0) ? "-#{headers[id]}" : ''
          headers[id] += 1
          if header_content = node.children.first
            entries << {
                id: id,
                uniq: uniq,
                text: text,
                content_node: header_content
            }
          end
        end

        entries
      end
    end
  end

  module TableOfContentsFilter
    def toc_only(html)
      page = @context.registers[:page]
      return html unless page['toc']

      Jekyll::TableOfContents::Parser.new(html).build_toc
    end

    def inject_anchors(html)
      page = @context.registers[:page]
      return html unless page['toc']

      Jekyll::TableOfContents::Parser.new(html).inject_anchors_into_html
    end

    def toc(html)
      page = @context.registers[:page]
      return html unless page['toc']

      Jekyll::TableOfContents::Parser.new(html).toc
    end
  end
end

Liquid::Template.register_filter(Jekyll::TableOfContentsFilter)
