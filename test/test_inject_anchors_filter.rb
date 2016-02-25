require 'test_helper'
require_relative '../lib/jekyll-toc'


class TestTOCOnlyFilter < Minitest::Test
  def setup
    @parser = Jekyll::TableOfContents::Parser.new(SIMPLE_HTML)
    assert_match /Simple H1/, @parser.doc.inner_html
  end

  def test_injects_anchors_into_content
    html = @parser.inject_anchors_into_html

    assert_match /<a id="simple\-h1" class="anchor" href="#simple\-h1" aria\-hidden="true"><span.*span><\/a>Simple H1/, html
  end

  def test_does_not_inject_toc
    html = @parser.inject_anchors_into_html

    assert_nil /<ul class="section-nav">/ =~ html
  end
end
