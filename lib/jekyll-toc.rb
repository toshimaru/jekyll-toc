require 'nokogiri'

module Jekyll
  # parse logic is from html-pipeline toc_filter
  # https://github.com/jch/html-pipeline/blob/v1.1.0/lib/html/pipeline/toc_filter.rb
  module TableOfContentsFilter
    PUNCTUATION_REGEXP = RUBY_VERSION > "1.9" ? /[^\p{Word}\- ]/u : /[^\w\- ]/

    def toc(html)
      toc = ""
      doc = Nokogiri::HTML::DocumentFragment.parse(html)
      headers = Hash.new(0)

      doc.css('h1, h2, h3, h4, h5, h6').each do |node|
        text = node.text
        id = text.downcase
        id.gsub!(PUNCTUATION_REGEXP, '') # remove punctuation
        id.gsub!(' ', '-') # replace spaces with dash

        uniq = (headers[id] > 0) ? "-#{headers[id]}" : ''
        headers[id] += 1
        if header_content = node.children.first
          toc << %Q{<li><a href="##{id}#{uniq}">#{text}</a></li>\n}
          header_content.add_previous_sibling(%Q{<a id="#{id}#{uniq}" class="anchor" href="##{id}#{uniq}" aria-hidden="true"><span class="octicon octicon-link"></span></a>})
        end
      end
      toc = %Q{<ul class="section-nav">\n#{toc}</ul>} unless toc.empty?

      toc + doc.inner_html
    end
  end
end

Liquid::Template.register_filter(Jekyll::TableOfContentsFilter)
