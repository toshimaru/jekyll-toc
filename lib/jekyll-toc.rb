require 'nokogiri'
require 'table_of_contents/parser'

module Jekyll
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
