require 'nokogiri'
require 'table_of_contents/parser'

module Jekyll
  class TocTag < Liquid::Tag
    def render(context)
      return unless context.registers[:page]['toc'] == true
      content_html = context.registers[:page].content
      ::Jekyll::TableOfContents::Parser.new(content_html).build_toc
    end
  end

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
# Liquid::Template.register_tag('toc', Jekyll::TocTag) # will be enabled at v1.0
