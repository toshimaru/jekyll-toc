# frozen_string_literal: true

module Jekyll
  # Helper methods for jekyll-toc
  module TableOfContents::Helper
    private

    def toc_enabled?
      @context.registers[:page]['toc'] == true
    end

    def toc_config
      @context.registers[:site].config['toc'] || {}
    end
  end
end
