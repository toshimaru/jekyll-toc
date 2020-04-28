# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-toc-navtotop'
  spec.version       = JekyllToc::VERSION
  spec.summary       = 'Jekyll Table of Contents plugin with navigation to top'
  spec.description   = 'Jekyll (Ruby static website generator) plugin which generates a table of contents and a navigation to top.'
  spec.authors       = ["n13.org", "KargWare", "N7K4", "toshimaru torbjoernk"]
  spec.email         = 'rubygems.org@n13.org'
  spec.files         = `git ls-files -z`.split("\x0")
  spec.homepage      = 'https://github.com/n13org/jekyll-toc-navtotop'
  spec.license       = 'MIT'
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.4'

  spec.add_dependency 'jekyll', '>= 3.7'
  spec.add_dependency 'nokogiri', '~> 1.9'
end
