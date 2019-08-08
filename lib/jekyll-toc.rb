# frozen_string_literal: true

require 'nokogiri'
require 'table_of_contents/configuration'
require 'table_of_contents/parser'

module Jekyll
  # toc tag for Jekyll
  class TocTag < Liquid::Tag
    def render(context)
      return '' unless context.registers[:page]['toc']

      content_html = context.registers[:page]['content']
      toc_config = context.registers[:site].config['toc'] || {}
      TableOfContents::Parser.new(content_html, toc_config).build_toc
    end
  end

  # Jekyll Table of Contents filter plugin
  module TableOfContentsFilter
    # Deprecated method. Removed in v1.0.
    def toc_only(html)
      return '' unless toc_enabled?

      TableOfContents::Parser.new(html, toc_config).build_toc
    end

    def inject_anchors(html)
      return html unless toc_enabled?

      TableOfContents::Parser.new(html, toc_config).inject_anchors_into_html
    end

    def toc(html)
      return html unless toc_enabled?

      TableOfContents::Parser.new(html, toc_config).toc
    end

    private

    def toc_enabled?
      @context.registers[:page]['toc'] == true
    end

    def toc_config
      @context.registers[:site].config['toc'] || {}
    end
  end
end

Liquid::Template.register_filter(Jekyll::TableOfContentsFilter)
Liquid::Template.register_tag('toc', Jekyll::TocTag) # will be enabled at v1.0
