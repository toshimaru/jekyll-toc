require 'test_helper'
require_relative '../lib/jekyll-toc'


class TestTOCOnlyFilter < Minitest::Test
  def setup
    @parser = Jekyll::TableOfContents::Parser.new(SIMPLE_HTML)
    assert_match /Simple H1/, @parser.doc.inner_html
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
