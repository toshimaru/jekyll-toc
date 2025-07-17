# frozen_string_literal: true

require 'test_helper'

class TestDivList < Minitest::Test
  TEST_HTML = '<h1>h1</h1><h2>h2</h2><h3>h3</h3>'

  def test_basic_div_toc
    parser = Jekyll::TableOfContents::Parser.new(TEST_HTML, 'div_list' => true)
    html = parser.build_toc

    assert_match(/^<div id="toc" class="section-nav">/, html)
    assert_match(%r{<div class="toc-entry toc-h1"><a href="#h1">h1</a>}, html)
    assert_match(%r{<div class="toc-entry toc-h2"><a href="#h2">h2</a>}, html)
    assert_match(%r{<div class="toc-entry toc-h3"><a href="#h3">h3</a></div>}, html)
    refute_match(/<ul/, html)
    refute_match(/<ol/, html)
  end

  def test_div_toc_with_custom_classes
    parser = Jekyll::TableOfContents::Parser.new(TEST_HTML, {
                                                   'div_list' => true,
                                                   'list_id' => 'custom-toc-id',
                                                   'list_class' => 'custom-list',
                                                   'sublist_class' => 'custom-sublist',
                                                   'item_class' => 'custom-item',
                                                   'item_prefix' => 'custom-prefix-'
                                                 })
    html = parser.build_toc

    assert_match(/^<div id="custom-toc-id" class="custom-list">/, html)
    assert_match(%r{<div class="custom-item custom-prefix-h1"><a href="#h1">h1</a>}, html)
    assert_match(%r{<div class="custom-item custom-prefix-h2"><a href="#h2">h2</a>}, html)
    assert_match(%r{<div class="custom-item custom-prefix-h3"><a href="#h3">h3</a></div>}, html)
    assert_match(/<div class="custom-sublist">/, html)
    refute_match(/<ul/, html)
    refute_match(/<ol/, html)
  end

  def test_div_toc_ignores_ordered_list
    parser = Jekyll::TableOfContents::Parser.new(TEST_HTML, {
                                                   'div_list' => true,
                                                   'ordered_list' => true
                                                 })
    html = parser.build_toc

    assert_match(/^<div id="toc" class="section-nav">/, html)
    refute_match(/<ol/, html)
    refute_match(/<ul/, html)
  end
end
