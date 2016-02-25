require 'test_helper'
require_relative '../lib/jekyll-toc'


class TestTOCOnlyFilter < Minitest::Test
  include TestHelpers

  def setup
    read_html_and_create_parser
  end

  def test_injects_toc_container
    html = @parser.build_toc

    assert_match /<ul class="section-nav">/, html
  end

  def test_does_not_return_content
    html = @parser.build_toc

    assert_nil /<h1>Simple H1<\/h1>/ =~ html
  end
end
