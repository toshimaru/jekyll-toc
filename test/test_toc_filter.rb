require 'test_helper'
require_relative '../lib/jekyll-toc'


class TestTOCFilter < Minitest::Test
  def setup
    @parser = Jekyll::TableOfContents::Parser.new(SIMPLE_HTML)
    assert_match /Simple H1/, @parser.doc.inner_html
  end

  def test_injects_anchors
    html = @parser.toc

    assert_match /<a id="simple\-h1" class="anchor" href="#simple\-h1" aria\-hidden="true"><span.*span><\/a>Simple H1/, html
  end

  def test_injects_toc_container
    html = @parser.toc

    assert_match /<ul class="section-nav">/, html
  end
end
