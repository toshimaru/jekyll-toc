# frozen_string_literal: true

require 'test_helper'

class TestVariousTocHtml < Minitest::Test
  # ref. https://github.com/toshimaru/jekyll-toc/issues/45
  ANGLE_BRACKET_HTML = <<~HTML
    <h1>h1</h1>
    <h1>&lt;base href&gt;</h1>
    <h1>&amp; &lt; &gt;</h1>
  HTML

  NO_TOC_HTML = <<~HTML
    <h1>h1</h1>
    <h1 class="no_toc">no_toc h1</h1>
    <h2>h2</h2>
    <h2 class="no_toc">no_toc h2</h2>
    <h3>h3</h3>
    <h3 class="no_toc">no_toc h3</h3>
    <h4>h4</h4>
    <h4 class="no_toc">no_toc h4</h4>
  HTML

  JAPANESE_HEADINGS_HTML = <<~HTML
    <h1>あ</h1>
    <h2>い</h2>
    <h3>う</h3>
  HTML

  TAGS_INSIDE_HEADINGS_HTML = <<~HTML
    <h2><strong>h2</strong></h2>
    <h2><em>h2</em></h2>
  HTML

  TEST_HTML_1 = <<~HTML
    <h1>h1</h1>
    <h3>h3</h3>
    <h6>h6</h6>
  HTML

  TEST_HTML_2 = <<~HTML
    <h1>h1</h1>
    <h3>h3</h3>
    <h2>h2</h2>
    <h6>h6</h6>
  HTML

  TEST_HTML_3 = <<~HTML
    <h6>h6</h6>
    <h5>h5</h5>
    <h4>h4</h4>
    <h3>h3</h3>
    <h2>h2</h2>
    <h1>h1</h1>
  HTML

  TEST_HTML_4 = <<~HTML
    <h1>h1</h1>
    <h3>h3</h3>
    <h2>h2</h2>
    <h4>h4</h4>
    <h5>h5</h5>
  HTML

  def test_nested_toc
    parser = Jekyll::TableOfContents::Parser.new(TEST_HTML_1)
    doc = Nokogiri::HTML(parser.toc)
    expected = <<~HTML
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
    parser = Jekyll::TableOfContents::Parser.new(TEST_HTML_1, 'min_level' => 2, 'max_level' => 5)
    doc = Nokogiri::HTML(parser.toc)
    expected = <<~HTML
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
    expected = <<~HTML
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
    expected = <<~HTML
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
    expected = <<~HTML
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
    expected = <<~HTML
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
    expected = <<~HTML
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
    expected = <<~HTML
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
    expected = <<~HTML
      <ul class="section-nav">
      <li class="toc-entry toc-h2"><a href="#h2">h2</a></li>
      <li class="toc-entry toc-h2"><a href="#h2-1">h2</a></li>
      </ul>
    HTML
    actual = doc.css('ul.section-nav').to_s

    assert_equal(expected, actual)
  end

  TEST_HTML_IGNORE = <<~HTML
    <h1>h1</h1>
    <div class="no_toc_section">
    <h2>h2</h2>
    </div>
    <h3>h3</h3>
    <h6>h6</h6>
  HTML

  def test_nested_toc_with_no_toc_section_class
    parser = Jekyll::TableOfContents::Parser.new(TEST_HTML_IGNORE)
    doc = Nokogiri::HTML(parser.toc)
    expected = <<~HTML
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

    html = parser.inject_anchors_into_html
    assert_match(%r{<h1 id="h1">.+</h1>}m, html)
    assert_match(%r{<h3 id="h3">.+</h3>}m, html)
    assert_match(%r{<h6 id="h6">.+</h6>}m, html)
    assert_includes(html, '<h2>h2</h2>')
  end

  TEST_HTML_IGNORE_2 = <<~HTML
    <h1>h1</h1>
    <div class="exclude">
    <h2>h2</h2>
    </div>
    <h3>h3</h3>
    <div class="exclude">
    <h4>h4</h4>
    <h5>h5</h5>
    </div>
    <h6>h6</h6>
  HTML

  def test_nested_toc_with_no_toc_section_class_option
    parser = Jekyll::TableOfContents::Parser.new(TEST_HTML_IGNORE_2, 'no_toc_section_class' => 'exclude')
    doc = Nokogiri::HTML(parser.toc)
    expected = <<~HTML
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

    html = parser.inject_anchors_into_html
    assert_match(%r{<h1 id="h1">.+</h1>}m, html)
    assert_match(%r{<h3 id="h3">.+</h3>}m, html)
    assert_match(%r{<h6 id="h6">.+</h6>}m, html)
    assert_includes(html, '<h2>h2</h2>')
    assert_includes(html, '<h4>h4</h4>')
    assert_includes(html, '<h5>h5</h5>')
  end

  TEST_HTML_IGNORE_3 = <<~HTML
    <h1>h1</h1>
    <div class="no_toc_section">
    <h2>h2</h2>
    </div>
    <h3>h3</h3>
    <div class="exclude">
    <h4>h4</h4>
    <h5>h5</h5>
    </div>
    <h6>h6</h6>
  HTML

  def test_multiple_no_toc_section_classes
    parser = Jekyll::TableOfContents::Parser.new(TEST_HTML_IGNORE_3, 'no_toc_section_class' => ['no_toc_section', 'exclude'])
    doc = Nokogiri::HTML(parser.toc)
    expected = <<~HTML
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

    html = parser.inject_anchors_into_html
    assert_match(%r{<h1 id="h1">.+</h1>}m, html)
    assert_match(%r{<h3 id="h3">.+</h3>}m, html)
    assert_match(%r{<h6 id="h6">.+</h6>}m, html)
    assert_includes(html, '<h2>h2</h2>')
    assert_includes(html, '<h4>h4</h4>')
    assert_includes(html, '<h5>h5</h5>')
  end

  TEST_EXPLICIT_ID = <<~HTML
    <h1>h1</h1>
    <h1 id="second">h2</h1>
    <h1 id="third">h3</h1>
  HTML

  def test_toc_with_explicit_id
    parser = Jekyll::TableOfContents::Parser.new(TEST_EXPLICIT_ID)
    doc = Nokogiri::HTML(parser.toc)
    expected = <<~HTML
      <ul class="section-nav">
      <li class="toc-entry toc-h1"><a href="#h1">h1</a></li>
      <li class="toc-entry toc-h1"><a href="#second">h2</a></li>
      <li class="toc-entry toc-h1"><a href="#third">h3</a></li>
      </ul>
    HTML
    actual = doc.css('ul.section-nav').to_s
    assert_equal(expected, actual)

    html = parser.inject_anchors_into_html
    assert_includes(html, %(<a class="anchor" href="#h1" aria-hidden="true">))
    assert_includes(html, %(<a class="anchor" href="#second" aria-hidden="true">))
    assert_includes(html, %(<a class="anchor" href="#third" aria-hidden="true">))
  end

  TEST_UNIQ_ID = <<~HTML
    <h1>h1</h1>
    <h1>h1</h1>
    <h1>h1</h1>
  HTML

  def test_anchor_is_uniq
    parser = Jekyll::TableOfContents::Parser.new(TEST_UNIQ_ID)
    doc = Nokogiri::HTML(parser.toc)
    expected = <<~HTML
      <ul class="section-nav">
      <li class="toc-entry toc-h1"><a href="#h1">h1</a></li>
      <li class="toc-entry toc-h1"><a href="#h1-1">h1</a></li>
      <li class="toc-entry toc-h1"><a href="#h1-2">h1</a></li>
      </ul>
    HTML
    actual = doc.css('ul.section-nav').to_s
    assert_equal(expected, actual)
  end

  def test_custom_css_classes
    parser = Jekyll::TableOfContents::Parser.new(
      TEST_HTML_1,
      'item_class' => 'custom-item', 'list_class' => 'custom-list', 'sublist_class' => 'custom-sublist', 'item_prefix' => 'custom-prefix-'
    )
    doc = Nokogiri::HTML(parser.toc)
    expected = <<~HTML
      <ul class="custom-list">
      <li class="custom-item custom-prefix-h1">
      <a href="#h1">h1</a>
      <ul class="custom-sublist">
      <li class="custom-item custom-prefix-h3">
      <a href="#h3">h3</a>
      <ul class="custom-sublist">
      <li class="custom-item custom-prefix-h6"><a href="#h6">h6</a></li>
      </ul>
      </li>
      </ul>
      </li>
      </ul>
    HTML

    assert_equal(expected, doc.css('ul.custom-list').to_s)
  end
end
