# frozen_string_literal: true
require 'test_helper'

class TestOptionError < Minitest::Test
  BASE_HTML = '<h1>h1</h1>'
  EXPECTED_HTML = <<~HTML
    <ul id="toc" class="section-nav">
    <li class="toc-entry toc-h1"><a href="#h1">h1</a></li>
    </ul>
  HTML

  def test_option_is_nil
    parser = Jekyll::TableOfContents::Parser.new(BASE_HTML, nil)
    doc = Nokogiri::HTML(parser.toc)
    expected = EXPECTED_HTML
    assert_equal(expected, doc.css('ul.section-nav').to_s)
  end

  def test_option_is_epmty_string
    parser = Jekyll::TableOfContents::Parser.new(BASE_HTML, '')
    doc = Nokogiri::HTML(parser.toc)
    expected = EXPECTED_HTML
    assert_equal(expected, doc.css('ul.section-nav').to_s)
  end

  def test_option_is_string
    parser = Jekyll::TableOfContents::Parser.new(BASE_HTML, 'string')
    doc = Nokogiri::HTML(parser.toc)
    expected = EXPECTED_HTML
    assert_equal(expected, doc.css('ul.section-nav').to_s)
  end

  def test_option_is_array
    parser = Jekyll::TableOfContents::Parser.new(BASE_HTML, [])
    doc = Nokogiri::HTML(parser.toc)
    expected = EXPECTED_HTML
    assert_equal(expected, doc.css('ul.section-nav').to_s)
  end
end
