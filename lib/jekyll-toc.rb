module Jekyll
  module TableOfContentsFilter
    def toc
    end
  end
end

Liquid::Template.register_filter(Jekyll::TableOfContentsFilter)
