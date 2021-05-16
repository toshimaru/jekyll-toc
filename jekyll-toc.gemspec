# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'table_of_contents/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-toc'
  spec.version       = Jekyll::TableOfContents::VERSION
  spec.summary       = 'Jekyll Table of Contents plugin'
  spec.description   = 'Jekyll (Ruby static website generator) plugin which generates a Table of Contents for the page.'
  spec.authors       = %w(toshimaru torbjoernk)
  spec.email         = 'me@toshimaru.net'
  spec.files         = `git ls-files -z`.split("\x0")
  spec.homepage      = 'https://github.com/toshimaru/jekyll-toc'
  spec.license       = 'MIT'
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.5'

  spec.add_dependency 'jekyll', '>= 3.9'
  spec.add_dependency 'nokogiri', '~> 1.11'
end
