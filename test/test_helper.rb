# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require 'jekyll'
require 'jekyll-toc'

SIMPLE_HTML = <<~HTML
  <h1>Simple H1</h1>
  <h2>Simple H2</h2>
  <h3>Simple H3</h3>
  <h4>Simple H4</h4>
  <h5>Simple H5</h5>
  <h6>Simple H6</h6>
HTML

module TestHelpers
  def read_html_and_create_parser(options = {})
    @parser = Jekyll::TableOfContents::Parser.new(SIMPLE_HTML, options)
  end
end
