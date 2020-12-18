# frozen_string_literal: true

require 'test_helper'

class TestVariousTocHtml < Minitest::Test
  TEST_HTML = <<~HTML
    <h1>h1</h1>
    <h3>h3</h3>
    <h6>h6</h6>
  HTML

  def test_nested_toc
    parser = Jekyll::TableOfContents::Parser.new(TEST_HTML)
    expected = <<~HTML.chomp
      <ul id="toc" class="section-nav">
      <li class="toc-entry toc-h1"><a href="#h1">h1</a>
      <ul>
      <li class="toc-entry toc-h3"><a href="#h3">h3</a>
      <ul>
      <li class="toc-entry toc-h6"><a href="#h6">h6</a></li>
      </ul>
      </li>
      </ul>
      </li>
      </ul>
    HTML

    assert_equal(expected, parser.build_toc)
  end

  def test_nested_toc_with_min_and_max
    parser = Jekyll::TableOfContents::Parser.new(TEST_HTML, 'min_level' => 2, 'max_level' => 5)
    expected = <<~HTML.chomp
      <ul id="toc" class="section-nav">
      <li class="toc-entry toc-h3"><a href="#h3">h3</a></li>
      </ul>
    HTML

    assert_equal(expected, parser.build_toc)
  end

  def test_complex_nested_toc
    parser = Jekyll::TableOfContents::Parser.new(<<~HTML)
      <h1>h1</h1>
      <h3>h3</h3>
      <h2>h2</h2>
      <h6>h6</h6>
    HTML
    expected = <<~HTML.chomp
      <ul id="toc" class="section-nav">
      <li class="toc-entry toc-h1"><a href="#h1">h1</a>
      <ul>
      <li class="toc-entry toc-h3"><a href="#h3">h3</a></li>
      <li class="toc-entry toc-h2"><a href="#h2">h2</a>
      <ul>
      <li class="toc-entry toc-h6"><a href="#h6">h6</a></li>
      </ul>
      </li>
      </ul>
      </li>
      </ul>
    HTML

    assert_equal(expected, parser.build_toc)
  end

  def test_decremental_headings1
    parser = Jekyll::TableOfContents::Parser.new(<<~HTML)
      <h6>h6</h6>
      <h5>h5</h5>
      <h4>h4</h4>
      <h3>h3</h3>
      <h2>h2</h2>
      <h1>h1</h1>
    HTML
    expected = <<~HTML.chomp
      <ul id="toc" class="section-nav">
      <li class="toc-entry toc-h6"><a href="#h6">h6</a></li>
      <li class="toc-entry toc-h5"><a href="#h5">h5</a></li>
      <li class="toc-entry toc-h4"><a href="#h4">h4</a></li>
      <li class="toc-entry toc-h3"><a href="#h3">h3</a></li>
      <li class="toc-entry toc-h2"><a href="#h2">h2</a></li>
      <li class="toc-entry toc-h1"><a href="#h1">h1</a></li>
      </ul>
    HTML

    assert_equal(expected, parser.build_toc)
  end

  def test_decremental_headings2
    parser = Jekyll::TableOfContents::Parser.new(<<~HTML)
      <h1>h1</h1>
      <h3>h3</h3>
      <h2>h2</h2>
      <h4>h4</h4>
      <h5>h5</h5>
    HTML
    expected = <<~HTML.chomp
      <ul id="toc" class="section-nav">
      <li class="toc-entry toc-h1"><a href="#h1">h1</a>
      <ul>
      <li class="toc-entry toc-h3"><a href="#h3">h3</a></li>
      <li class="toc-entry toc-h2"><a href="#h2">h2</a>
      <ul>
      <li class="toc-entry toc-h4"><a href="#h4">h4</a>
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

    assert_equal(expected, parser.build_toc)
  end

  def test_no_toc
    parser = Jekyll::TableOfContents::Parser.new(<<~HTML)
      <h1>h1</h1>
      <h1 class="no_toc">no_toc h1</h1>
      <h2>h2</h2>
      <h2 class="no_toc">no_toc h2</h2>
      <h3>h3</h3>
      <h3 class="no_toc">no_toc h3</h3>
      <h4>h4</h4>
      <h4 class="no_toc">no_toc h4</h4>
    HTML
    expected = <<~HTML.chomp
      <ul id="toc" class="section-nav">
      <li class="toc-entry toc-h1"><a href="#h1">h1</a>
      <ul>
      <li class="toc-entry toc-h2"><a href="#h2">h2</a>
      <ul>
      <li class="toc-entry toc-h3"><a href="#h3">h3</a>
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

    assert_equal(expected, parser.build_toc)
  end

  def test_japanese_toc
    parser = Jekyll::TableOfContents::Parser.new(<<~HTML)
      <h1>あ</h1>
      <h2>い</h2>
      <h3>う</h3>
    HTML
    expected = <<~HTML.chomp
      <ul id="toc" class="section-nav">
      <li class="toc-entry toc-h1"><a href="#%E3%81%82">あ</a>
      <ul>
      <li class="toc-entry toc-h2"><a href="#%E3%81%84">い</a>
      <ul>
      <li class="toc-entry toc-h3"><a href="#%E3%81%86">う</a></li>
      </ul>
      </li>
      </ul>
      </li>
      </ul>
    HTML

    assert_equal(expected, parser.build_toc)
    html_with_anchors = parser.inject_anchors_into_html
    assert_match(%r{<a class="anchor" href="#%E3%81%82" aria-hidden="true"><span.*span></a>あ}, html_with_anchors)
    assert_match(%r{<a class="anchor" href="#%E3%81%84" aria-hidden="true"><span.*span></a>い}, html_with_anchors)
    assert_match(%r{<a class="anchor" href="#%E3%81%86" aria-hidden="true"><span.*span></a>う}, html_with_anchors)
  end

  # ref. https://github.com/toshimaru/jekyll-toc/issues/45
  def test_angle_bracket
    parser = Jekyll::TableOfContents::Parser.new(<<~HTML)
      <h1>h1</h1>
      <h1>&lt;base href&gt;</h1>
      <h1>&amp; &lt; &gt;</h1>
    HTML
    expected = <<~HTML.chomp
      <ul id="toc" class="section-nav">
      <li class="toc-entry toc-h1"><a href="#h1">h1</a></li>
      <li class="toc-entry toc-h1"><a href="#base-href">&lt;base href&gt;</a></li>
      <li class="toc-entry toc-h1"><a href="#--">&amp; &lt; &gt;</a></li>
      </ul>
    HTML

    assert_equal(expected, parser.build_toc)
  end

  def test_tags_inside_heading
    parser = Jekyll::TableOfContents::Parser.new(<<~HTML)
      <h2><strong>h2</strong></h2>
      <h2><em>h2</em></h2>
    HTML
    expected = <<~HTML.chomp
      <ul id="toc" class="section-nav">
      <li class="toc-entry toc-h2"><a href="#h2">h2</a></li>
      <li class="toc-entry toc-h2"><a href="#h2-1">h2</a></li>
      </ul>
    HTML

    assert_equal(expected, parser.build_toc)
  end

  def test_nested_toc_with_no_toc_section_class
    parser = Jekyll::TableOfContents::Parser.new(<<~HTML)
      <h1>h1</h1>
      <div class="no_toc_section">
      <h2>h2</h2>
      </div>
      <h3>h3</h3>
      <h6>h6</h6>
    HTML
    expected = <<~HTML.chomp
      <ul id="toc" class="section-nav">
      <li class="toc-entry toc-h1"><a href="#h1">h1</a>
      <ul>
      <li class="toc-entry toc-h3"><a href="#h3">h3</a>
      <ul>
      <li class="toc-entry toc-h6"><a href="#h6">h6</a></li>
      </ul>
      </li>
      </ul>
      </li>
      </ul>
    HTML
    assert_equal(expected, parser.build_toc)

    html = parser.inject_anchors_into_html
    assert_match(%r{<h1>.+</h1>}m, html)
    assert_match(%r{<h3>.+</h3>}m, html)
    assert_match(%r{<h6>.+</h6>}m, html)
    assert_includes(html, '<h2>h2</h2>')
  end

  def test_nested_toc_with_no_toc_section_class_option
    parser = Jekyll::TableOfContents::Parser.new(<<~HTML, 'no_toc_section_class' => 'exclude')
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
    expected = <<~HTML.chomp
      <ul id="toc" class="section-nav">
      <li class="toc-entry toc-h1"><a href="#h1">h1</a>
      <ul>
      <li class="toc-entry toc-h3"><a href="#h3">h3</a>
      <ul>
      <li class="toc-entry toc-h6"><a href="#h6">h6</a></li>
      </ul>
      </li>
      </ul>
      </li>
      </ul>
    HTML
    assert_equal(expected, parser.build_toc)

    html = parser.inject_anchors_into_html
    assert_match(%r{<h1>.+</h1>}m, html)
    assert_match(%r{<h3>.+</h3>}m, html)
    assert_match(%r{<h6>.+</h6>}m, html)
    assert_includes(html, '<h2>h2</h2>')
    assert_includes(html, '<h4>h4</h4>')
    assert_includes(html, '<h5>h5</h5>')
  end

  def test_multiple_no_toc_section_classes
    parser = Jekyll::TableOfContents::Parser.new(<<~HTML, 'no_toc_section_class' => ['no_toc_section', 'exclude'])
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
    expected = <<~HTML.chomp
      <ul id="toc" class="section-nav">
      <li class="toc-entry toc-h1"><a href="#h1">h1</a>
      <ul>
      <li class="toc-entry toc-h3"><a href="#h3">h3</a>
      <ul>
      <li class="toc-entry toc-h6"><a href="#h6">h6</a></li>
      </ul>
      </li>
      </ul>
      </li>
      </ul>
    HTML
    assert_equal(expected, parser.build_toc)

    html = parser.inject_anchors_into_html
    assert_match(%r{<h1>.+</h1>}m, html)
    assert_match(%r{<h3>.+</h3>}m, html)
    assert_match(%r{<h6>.+</h6>}m, html)
    assert_includes(html, '<h2>h2</h2>')
    assert_includes(html, '<h4>h4</h4>')
    assert_includes(html, '<h5>h5</h5>')
  end

  def test_toc_with_explicit_id
    parser = Jekyll::TableOfContents::Parser.new(<<~HTML)
      <h1>h1</h1>
      <h1 id="second">h2</h1>
      <h1 id="third">h3</h1>
    HTML
    expected = <<~HTML.chomp
      <ul id="toc" class="section-nav">
      <li class="toc-entry toc-h1"><a href="#h1">h1</a></li>
      <li class="toc-entry toc-h1"><a href="#second">h2</a></li>
      <li class="toc-entry toc-h1"><a href="#third">h3</a></li>
      </ul>
    HTML
    assert_equal(expected, parser.build_toc)

    html = parser.inject_anchors_into_html
    assert_includes(html, %(<a class="anchor" href="#h1" aria-hidden="true">))
    assert_includes(html, %(<a class="anchor" href="#second" aria-hidden="true">))
    assert_includes(html, %(<a class="anchor" href="#third" aria-hidden="true">))
  end

  def test_anchor_is_uniq
    parser = Jekyll::TableOfContents::Parser.new(<<~HTML)
      <h1>h1</h1>
      <h1>h1</h1>
      <h1>h1</h1>
    HTML
    expected = <<~HTML.chomp
      <ul id="toc" class="section-nav">
      <li class="toc-entry toc-h1"><a href="#h1">h1</a></li>
      <li class="toc-entry toc-h1"><a href="#h1-1">h1</a></li>
      <li class="toc-entry toc-h1"><a href="#h1-2">h1</a></li>
      </ul>
    HTML

    assert_equal(expected, parser.build_toc)
  end

  def test_custom_css_classes
    parser = Jekyll::TableOfContents::Parser.new(
      TEST_HTML,
      'item_class' => 'custom-item', 'list_id' => 'custom-toc-id', 'list_class' => 'custom-list', 'sublist_class' => 'custom-sublist', 'item_prefix' => 'custom-prefix-'
    )
    expected = <<~HTML.chomp
      <ul id="custom-toc-id" class="custom-list">
      <li class="custom-item custom-prefix-h1"><a href="#h1">h1</a>
      <ul class="custom-sublist">
      <li class="custom-item custom-prefix-h3"><a href="#h3">h3</a>
      <ul class="custom-sublist">
      <li class="custom-item custom-prefix-h6"><a href="#h6">h6</a></li>
      </ul>
      </li>
      </ul>
      </li>
      </ul>
    HTML

    assert_equal(expected, parser.build_toc)
  end
end
