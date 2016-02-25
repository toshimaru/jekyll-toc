require 'test_helper'
require_relative '../lib/jekyll-toc'


class TestTOCParser < Minitest::Test
  SIMPLE_HTML = <<EOL
<h1>Simple H1</h1>
<h2>Simple H2</h2>
<h3>Simple H3</h3>
<h4>Simple H4</h4>
<h5>Simple H5</h5>
<h6>Simple H6</h6>
EOL

  def setup
    @data = SIMPLE_HTML
    @parser = Jekyll::TableOfContentsFilter::Parser
  end

  def test_example_html_is_loaded
    assert_match /Simple H1/, @data
  end

  def test_injects_anchors
    html = @parser.toc(@data)

    assert_match /<a id="simple\-h1" class="anchor" href="#simple\-h1" aria\-hidden="true"><span.*span><\/a>Simple H1/, html
  end

  def test_injects_toc_container
    html = @parser.toc(@data)

    assert_match /<ul class="section-nav">/, html
  end
end
