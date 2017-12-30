require 'test_helper'

class TestOptionError < Minitest::Test
  def test_option_is_nil
    parser = Jekyll::TableOfContents::Parser.new("<h1>h1</h1>", nil)
    doc = Nokogiri::HTML(parser.toc)
    expected = <<-HTML
<ul class="section-nav">
<li class="toc-entry toc-h1"><a href="#h1">h1</a></li>
</ul>
    HTML
    assert_equal(expected, doc.css('ul.section-nav').to_s)
  end

  def test_option_is_string
    parser = Jekyll::TableOfContents::Parser.new("<h1>h1</h1>", "string")
    doc = Nokogiri::HTML(parser.toc)
    expected = <<-HTML
<ul class="section-nav">
<li class="toc-entry toc-h1"><a href="#h1">h1</a></li>
</ul>
    HTML
    assert_equal(expected, doc.css('ul.section-nav').to_s)
  end

  def test_option_is_array
    parser = Jekyll::TableOfContents::Parser.new("<h1>h1</h1>", [])
    doc = Nokogiri::HTML(parser.toc)
    expected = <<-HTML
<ul class="section-nav">
<li class="toc-entry toc-h1"><a href="#h1">h1</a></li>
</ul>
    HTML
    assert_equal(expected, doc.css('ul.section-nav').to_s)
  end
end
