# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require 'jekyll'
require 'jekyll-toc'
require 'table_of_contents/configuration'

SIMPLE_HTML_WITH_IDS = <<~HTML
  <h1 id="123">Simple H1</h1>
  <h2>Simple H2a</h2>
  <h2>Simple H2b</h2>
  <h3 id="sub-h3">Simple H3a</h3>
  <h3>Simple H3b</h3>
  <h3>Simple H3c ÜÄÖ</h3>
HTML

module TestHelpersEncoding
  def read_html_and_create_parser(anchor_id_url_encoded)
    @parser = Jekyll::TableOfContents::Parser.new(SIMPLE_HTML_WITH_IDS)
    @config = Jekyll::TableOfContents::Configuration.new({})
    @config.anchor_id_url_encoded = anchor_id_url_encoded
  end
end
