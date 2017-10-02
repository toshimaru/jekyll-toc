require 'test_helper'

class TestVariousTocHtml < Minitest::Test
  def test_nested_toc
    html = <<-HTML
<h1>h1</h1>
<h3>h3</h3>
<h6>h6</h6>
    HTML

    @parser = Jekyll::TableOfContents::Parser.new(html)
    doc = Nokogiri::HTML(@parser.toc)

    assert_equal(doc.css('ul.section-nav').to_s, <<-HTML
<ul class="section-nav">
<li class="toc-entry toc-h1">
<a href="#h1">h1</a>
<ul>
<li class="toc-entry toc-h3">
<a href="#h3">h3</a>
<ul>
<li class="toc-entry toc-h6"><a href="#h6">h6</a></li>
</ul>
</li>
</ul>
</li>
</ul>
    HTML
    )
  end
end
