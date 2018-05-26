require 'nokogiri'
require 'table_of_contents/parser'

module Jekyll
  class TocTag < Liquid::Tag
    def render(context)   
      return unless context.registers[:page]['toc'] == true || context.registers[:page]['toc'].is_a?(Hash)

      content_html = context.registers[:page].content

      if context.registers[:page]['toc'] == true
        ::Jekyll::TableOfContents::Parser.new(content_html).build_toc
      else # it's a hash
        ::Jekyll::TableOfContents::Parser.new(content_html,context.registers[:page]['toc']).build_toc
      end
     
    end
  end

  module TableOfContentsFilter
    def toc_only(html)
      return html unless toc_enabled?
      ::Jekyll::TableOfContents::Parser.new(html, toc_config).build_toc
    end

    def inject_anchors(html)
      return html unless toc_enabled?
      ::Jekyll::TableOfContents::Parser.new(html, toc_config).inject_anchors_into_html
    end

    def toc(html)
      return html unless toc_enabled?
      ::Jekyll::TableOfContents::Parser.new(html, toc_config).toc
    end

    private

    def toc_enabled?
      @context.registers[:page]['toc'] == true || @context.registers[:page]['toc'].is_a?(Hash)
    end

    def toc_config

      global_config = @context.registers[:site].config["toc"]

      local_config = @context.registers[:page]["toc"]

      if global_config.is_a?(Hash) && !(local_config.is_a?(Hash))
        global_config
      elsif global_config.is_a?(Hash) && local_config.is_a?(Hash)
        global_config.merge(local_config) # local takes precedence
      elsif !(global_config.is_a?(Hash)) && local_config.is_a?(Hash)
        local_config
      else # neither are set
        {}
      end

    end
  end
end

Liquid::Template.register_filter(Jekyll::TableOfContentsFilter)
# Liquid::Template.register_tag('toc', Jekyll::TocTag) # will be enabled at v1.0
