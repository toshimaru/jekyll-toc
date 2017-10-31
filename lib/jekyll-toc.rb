require 'nokogiri'
require 'table_of_contents/parser'

module Jekyll
  module TableOfContentsFilter
    def toc_only(html)
      return html unless toc_enabled?
      ::Jekyll::TableOfContents::Parser.new(html).build_toc
    end

    def inject_anchors(html)
      return html unless toc_enabled?
      ::Jekyll::TableOfContents::Parser.new(html).inject_anchors_into_html
    end

    def toc(html)
      return html unless toc_enabled?
      ::Jekyll::TableOfContents::Parser.new(html).toc
    end

    private

    def toc_enabled?
      page['toc'] == true
    end

    def page
      @context.registers[:page]
    end
  end
end

Liquid::Template.register_filter(Jekyll::TableOfContentsFilter)
