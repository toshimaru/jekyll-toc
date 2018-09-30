# frozen_string_literal: true

require 'test_helper'

class TestVariousTocHtml < Minitest::Test
  # ref. https://github.com/toshimaru/jekyll-toc/issues/45
  ANGLE_BRACKET_HTML = <<-HTML
<h1>h1</h1>
<h1>&lt;base href&gt;</h1>
<h1>&amp; &lt; &gt;</h1>
  HTML

  NO_TOC_HTML = <<-HTML
<h1>h1</h1>
<h1 class="no_toc">no_toc h1</h1>
<h2>h2</h2>
<h2 class="no_toc">no_toc h2</h2>
<h3>h3</h3>
<h3 class="no_toc">no_toc h3</h3>
<h4>h4</h4>
<h4 class="no_toc">no_toc h4</h4>
  HTML

  JAPANESE_HEADINGS_HTML = <<-HTML
<h1>あ</h1>
<h2>い</h2>
<h3>う</h3>
  HTML

  TAGS_INSIDE_HEADINGS_HTML = <<-HTML
<h2><strong>h2</strong></h2>
<h2><em>h2</em></h2>
  HTML

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

  TEST_HTML_4 = <<-HTML
<h1>h1</h1>
<h3>h3</h3>
<h2>h2</h2>
<h4>h4</h4>
<h5>h5</h5>
  HTML

  def test_nested_toc
    parser = Jekyll::TableOfContents::Parser.new(TEST_HTML_1)
    doc = Nokogiri::HTML(parser.toc)
    expected = <<-HTML
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
    actual = doc.css('ul.section-nav').to_s

    assert_equal(expected, actual)
  end

  def test_nested_toc_with_min_and_max
    parser = Jekyll::TableOfContents::Parser.new(TEST_HTML_1, { "min_level" => 2, "max_level" => 5 })
    doc = Nokogiri::HTML(parser.toc)
    expected = <<-HTML
<ul class="section-nav">
<li class="toc-entry toc-h3"><a href="#h3">h3</a></li>
</ul>
    HTML
    actual = doc.css('ul.section-nav').to_s

    assert_equal(expected, actual)
  end

  def test_complex_nested_toc
    parser = Jekyll::TableOfContents::Parser.new(TEST_HTML_2)
    doc = Nokogiri::HTML(parser.toc)
    expected = <<-HTML
<ul class="section-nav">
<li class="toc-entry toc-h1">
<a href="#h1">h1</a>
<ul>
<li class="toc-entry toc-h3"><a href="#h3">h3</a></li>
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
    actual = doc.css('ul.section-nav').to_s

    assert_equal(expected, actual)
  end

  def test_decremental_headings1
    parser = Jekyll::TableOfContents::Parser.new(TEST_HTML_3)
    doc = Nokogiri::HTML(parser.toc)
    expected = <<-HTML
<ul class="section-nav">
<li class="toc-entry toc-h6"><a href="#h6">h6</a></li>
<li class="toc-entry toc-h5"><a href="#h5">h5</a></li>
<li class="toc-entry toc-h4"><a href="#h4">h4</a></li>
<li class="toc-entry toc-h3"><a href="#h3">h3</a></li>
<li class="toc-entry toc-h2"><a href="#h2">h2</a></li>
<li class="toc-entry toc-h1"><a href="#h1">h1</a></li>
</ul>
    HTML
    actual = doc.css('ul.section-nav').to_s

    assert_equal(expected, actual)
  end

  def test_decremental_headings2
    parser = Jekyll::TableOfContents::Parser.new(TEST_HTML_4)
    doc = Nokogiri::HTML(parser.toc)
    expected = <<-HTML
<ul class="section-nav">
<li class="toc-entry toc-h1">
<a href="#h1">h1</a>
<ul>
<li class="toc-entry toc-h3"><a href="#h3">h3</a></li>
<li class="toc-entry toc-h2">
<a href="#h2">h2</a>
<ul>
<li class="toc-entry toc-h4">
<a href="#h4">h4</a>
<ul>
<li class="toc-entry toc-h5"><a href="#h5">h5</a></li>
</ul>
</li>
</ul>
</li>
</ul>
</li>
</ul>
    HTML

    assert_equal(expected, doc.css('ul.section-nav').to_s)
  end

  def test_no_toc
    parser = Jekyll::TableOfContents::Parser.new(NO_TOC_HTML)
    doc = Nokogiri::HTML(parser.toc)
    expected = <<-HTML
<ul class="section-nav">
<li class="toc-entry toc-h1">
<a href="#h1">h1</a>
<ul>
<li class="toc-entry toc-h2">
<a href="#h2">h2</a>
<ul>
<li class="toc-entry toc-h3">
<a href="#h3">h3</a>
<ul>
<li class="toc-entry toc-h4"><a href="#h4">h4</a></li>
</ul>
</li>
</ul>
</li>
</ul>
</li>
</ul>
    HTML
    actual = doc.css('ul.section-nav').to_s

    assert_equal(expected, actual)
  end

  def test_japanese_toc
    parser = Jekyll::TableOfContents::Parser.new(JAPANESE_HEADINGS_HTML)
    doc = Nokogiri::HTML(parser.toc)
    expected = <<-HTML
<ul class="section-nav">
<li class="toc-entry toc-h1">
<a href="#%E3%81%82">あ</a>
<ul>
<li class="toc-entry toc-h2">
<a href="#%E3%81%84">い</a>
<ul>
<li class="toc-entry toc-h3"><a href="#%E3%81%86">う</a></li>
</ul>
</li>
</ul>
</li>
</ul>
    HTML
    actual = doc.css('ul.section-nav').to_s

    assert_equal(expected, actual)
  end

  def test_angle_bracket
    parser = Jekyll::TableOfContents::Parser.new(ANGLE_BRACKET_HTML)
    doc = Nokogiri::HTML(parser.toc)
    expected = <<-HTML
<ul class="section-nav">
<li class="toc-entry toc-h1"><a href="#h1">h1</a></li>
<li class="toc-entry toc-h1"><a href="#base-href">&lt;base href&gt;</a></li>
<li class="toc-entry toc-h1"><a href="#--">&amp; &lt; &gt;</a></li>
</ul>
    HTML
    actual = doc.css('ul.section-nav').to_s

    assert_equal(expected, actual)
  end

  def test_tags_inside_heading
    parser = Jekyll::TableOfContents::Parser.new(TAGS_INSIDE_HEADINGS_HTML)
    doc = Nokogiri::HTML(parser.toc)
    expected = <<-HTML
<ul class="section-nav">
<li class="toc-entry toc-h2"><a href="#h2">h2</a></li>
<li class="toc-entry toc-h2"><a href="#h2-1">h2</a></li>
</ul>
    HTML
    actual = doc.css('ul.section-nav').to_s

    assert_equal(expected, actual)
  end
end
