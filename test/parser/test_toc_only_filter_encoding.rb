# frozen_string_literal: true

require 'test_helper_encoding'

class TestTOCOnlyFilterEncodingOn < Minitest::Test
  include TestHelpersEncoding

  def setup
    read_html_and_create_parser(true)
  end

  def test_injects_toc_container_with_anchor_id_url_encoded
    html = @parser.build_toc

    assert_match(/<ul id="toc" class="section-nav">/, html)

    assert_match(/<a href="#123">/, html)
    assert_match(/<a href="#simple-h2a">/, html)
    assert_match(/<a href="#simple-h2b">/, html)
    assert_match(/<a href="#sub-h3">/, html)
    assert_match(/<a href="#simple-h3b">/, html)
    assert_match(/<a href="#simple-h3c ÜÄÖ">/, html)
  end

  def test_does_not_return_content
    html = @parser.build_toc

    assert_nil(%r{<h1 id="123">Simple H1</h1>} =~ html)
  end

  class TestTOCOnlyFilterEncodingOff < Minitest::Test
    include TestHelpersEncoding
    
    def setup
      read_html_and_create_parser(false)
    end

    def test_injects_toc_container_without_anchor_id_url_encoded
      html = @parser.build_toc
  
      assert_match(/<ul id="toc" class="section-nav">/, html)
  
      assert_match(/<a href="#123">/, html)
      assert_match(/<a href="#simple-h2a">/, html)
      assert_match(/<a href="#simple-h2b">/, html)
      assert_match(/<a href="#sub-h3">/, html)
      assert_match(/<a href="#simple-h3b">/, html)
      assert_match(/<a href="#simple-h3c-üäö">/, html)
    end
  end
end
