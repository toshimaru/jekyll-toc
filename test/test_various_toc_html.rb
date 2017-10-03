require 'test_helper'

class TestVariousTocHtml < Minitest::Test
  TEST_HTML_1 = <<-HTML
<h1>h1</h1>
<h3>h3</h3>
<h6>h6</h6>
  HTML

  TEST_HTML_2 = <<-HTML
<h1>h1</h1>
<h3>h3</h3>
<h2>h2</h2>
<h6>h6</h6>
  HTML

  TEST_HTML_3 = <<-HTML
<h6>h6</h6>
<h5>h5</h5>
<h4>h4</h4>
<h3>h3</h3>
<h2>h2</h2>
<h1>h1</h1>
  HTML

  def test_nested_toc
    @parser = Jekyll::TableOfContents::Parser.new(TEST_HTML_1)
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

  def test_complex_nested_toc
    @parser = Jekyll::TableOfContents::Parser.new(TEST_HTML_2)
    doc = Nokogiri::HTML(@parser.toc)
    assert_equal(doc.css('ul.section-nav').to_s, <<-HTML
<ul class="section-nav">
<li class="toc-entry toc-h1">
<a href="#h1">h1</a>
<ul>
<ul>
<li class="toc-entry toc-h3"><a href="#h3">h3</a></li>
</ul>
<li class="toc-entry toc-h2">
<a href="#h2">h2</a>
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

  def test_decremental_headings
    @parser = Jekyll::TableOfContents::Parser.new(TEST_HTML_3)
    doc = Nokogiri::HTML(@parser.toc)
    assert_equal(doc.css('ul.section-nav').to_s, <<-HTML
<ul class="section-nav">
<ul>
<ul>
<ul>
<ul>
<ul>
<li class="toc-entry toc-h6"><a href="#h6">h6</a></li>
</ul>
<li class="toc-entry toc-h5"><a href="#h5">h5</a></li>
</ul>
<li class="toc-entry toc-h4"><a href="#h4">h4</a></li>
</ul>
<li class="toc-entry toc-h3"><a href="#h3">h3</a></li>
</ul>
<li class="toc-entry toc-h2"><a href="#h2">h2</a></li>
</ul>
<li class="toc-entry toc-h1"><a href="#h1">h1</a></li>
</ul>
    HTML
    )
  end
end
