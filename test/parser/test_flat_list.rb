# frozen_string_literal: true

require 'test_helper'

class TestFlatList < Minitest::Test
  TEST_HTML = '<h1>h1</h1><h2>h2</h2><h3>h3</h3>'

  def test_basic_flat_toc
    parser = Jekyll::TableOfContents::Parser.new(TEST_HTML, 'flat_list' => true)
    html = parser.build_toc

    assert_match(/^<ul id="toc" class="section-nav">/, html)
    assert_match(%r{<li class="toc-entry toc-h1"><a href="#h1">h1</a></li>}, html)
    assert_match(%r{<li class="toc-entry toc-h2"><a href="#h2">h2</a></li>}, html)
    assert_match(%r{<li class="toc-entry toc-h3"><a href="#h3">h3</a></li>}, html)

    # Make sure there's no nested structure
    refute_match(%r{<ul>.+</ul>}m, html)
    refute_match(/<li>.+<ul>/m, html)
    refute_match(%r{</ul>.+</li>}m, html)
  end

  def test_flat_toc_with_custom_classes
    parser = Jekyll::TableOfContents::Parser.new(TEST_HTML, {
                                                   'flat_list' => true,
                                                   'list_id' => 'custom-toc-id',
                                                   'list_class' => 'custom-list',
                                                   'item_class' => 'custom-item',
                                                   'item_prefix' => 'custom-prefix-'
                                                 })
    html = parser.build_toc

    assert_match(/^<ul id="custom-toc-id" class="custom-list">/, html)
    assert_match(%r{<li class="custom-item custom-prefix-h1"><a href="#h1">h1</a></li>}, html)
    assert_match(%r{<li class="custom-item custom-prefix-h2"><a href="#h2">h2</a></li>}, html)
    assert_match(%r{<li class="custom-item custom-prefix-h3"><a href="#h3">h3</a></li>}, html)

    # Make sure there's no nested structure
    refute_match(%r{<ul>.+</ul>}m, html)
    refute_match(/<li>.+<ul>/m, html)
    refute_match(%r{</ul>.+</li>}m, html)
  end

  def test_flat_toc_works_with_ordered_list
    parser = Jekyll::TableOfContents::Parser.new(TEST_HTML, {
                                                   'flat_list' => true,
                                                   'ordered_list' => true
                                                 })
    html = parser.build_toc

    assert_match(/^<ol id="toc" class="section-nav">/, html)
    assert_match(%r{<li class="toc-entry toc-h1"><a href="#h1">h1</a></li>}, html)
    assert_match(%r{<li class="toc-entry toc-h2"><a href="#h2">h2</a></li>}, html)
    assert_match(%r{<li class="toc-entry toc-h3"><a href="#h3">h3</a></li>}, html)

    # Make sure there's no nested structure
    refute_match(%r{<ol>.+</ol>}m, html)
    refute_match(/<li>.+<ol>/m, html)
    refute_match(%r{</ol>.+</li>}m, html)
  end

  def test_flat_toc_with_div_list
    parser = Jekyll::TableOfContents::Parser.new(TEST_HTML, {
                                                   'flat_list' => true,
                                                   'div_list' => true
                                                 })
    html = parser.build_toc

    assert_match(/^<div id="toc" class="section-nav">/, html)
    assert_match(%r{<div class="toc-entry toc-h1"><a href="#h1">h1</a></div>}, html)
    assert_match(%r{<div class="toc-entry toc-h2"><a href="#h2">h2</a></div>}, html)
    assert_match(%r{<div class="toc-entry toc-h3"><a href="#h3">h3</a></div>}, html)

    # Make sure there's no nested structure
    refute_match(%r{<div>.+</div>}m, html)
    refute_match(/<div>.+<div class="toc-entry/m, html)
  end

  def test_complex_flat_toc
    parser = Jekyll::TableOfContents::Parser.new(<<~HTML, 'flat_list' => true)
      <h1>h1</h1>
      <h3>h3</h3>
      <h2>h2</h2>
      <h6>h6</h6>
    HTML
    html = parser.build_toc

    # All headings should be at the same level in flat list mode
    assert_match(/^<ul id="toc" class="section-nav">/, html)
    assert_match(%r{<li class="toc-entry toc-h1"><a href="#h1">h1</a></li>}, html)
    assert_match(%r{<li class="toc-entry toc-h3"><a href="#h3">h3</a></li>}, html)
    assert_match(%r{<li class="toc-entry toc-h2"><a href="#h2">h2</a></li>}, html)
    assert_match(%r{<li class="toc-entry toc-h6"><a href="#h6">h6</a></li>}, html)

    # Make sure there's no nested structure
    refute_match(%r{<ul>.+</ul>}m, html)
    refute_match(/<li>.+<ul>/m, html)
    refute_match(%r{</ul>.+</li>}m, html)
  end
end
