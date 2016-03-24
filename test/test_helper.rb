require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'jekyll'
require 'minitest/autorun'

SIMPLE_HTML = <<EOL
<h1>Simple H1</h1>
<h2>Simple H2</h2>
<h3>Simple H3</h3>
<h4>Simple H4</h4>
<h5>Simple H5</h5>
<h6>Simple H6</h6>
EOL

module TestHelpers
  def read_html_and_create_parser
    @parser = Jekyll::TableOfContents::Parser.new(SIMPLE_HTML)
    assert_match /Simple H1/, @parser.doc.inner_html
  end
end
