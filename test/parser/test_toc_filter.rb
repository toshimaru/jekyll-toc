# frozen_string_literal: true

require 'test_helper'

class TestTOCFilter < Minitest::Test
  include TestHelpers

  def setup
    read_html_and_create_parser
  end

  def test_injects_anchors
    html = @parser.toc

    assert_match(%r{<a class="anchor" href="#simple-h1" aria-hidden="true"><span.*span></a>Simple H1}, html)
  end

  def test_nested_toc
    doc = Nokogiri::HTML(@parser.toc)
    nested_h6_text = doc.css('ul.section-nav')
                        .css('li.toc-h1')
                        .css('li.toc-h2')
                        .css('li.toc-h3')
                        .css('li.toc-h4')
                        .css('li.toc-h5')
                        .css('li.toc-h6')
                        .text
    assert_equal('Simple H6', nested_h6_text)
  end

  def test_injects_toc_container
    html = @parser.toc

    assert_match(/<ul id="toc" class="section-nav">/, html)
  end
end
