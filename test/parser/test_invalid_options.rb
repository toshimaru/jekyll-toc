# frozen_string_literal: true

require 'test_helper'

class TestInvalidOptions < Minitest::Test
  BASE_HTML = '<h1>h1</h1>'
  EXPECTED_HTML = <<~HTML.chomp
    <ul id="toc" class="section-nav">
    <li class="toc-entry toc-h1"><a href="#h1">h1</a></li>
    </ul>
  HTML

  def test_option_is_nil
    parser = Jekyll::TableOfContents::Parser.new(BASE_HTML, nil)
    assert_equal(EXPECTED_HTML, parser.build_toc)
  end

  def test_option_is_epmty_string
    parser = Jekyll::TableOfContents::Parser.new(BASE_HTML, '')
    assert_equal(EXPECTED_HTML, parser.build_toc)
  end

  def test_option_is_string
    parser = Jekyll::TableOfContents::Parser.new(BASE_HTML, 'string')
    assert_equal(EXPECTED_HTML, parser.build_toc)
  end

  def test_option_is_array
    parser = Jekyll::TableOfContents::Parser.new(BASE_HTML, [])
    assert_equal(EXPECTED_HTML, parser.build_toc)
  end
end
