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

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_runtime_dependency 'nokogiri', '~> 1.9'

  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'jekyll', '>= 3.5'
  spec.add_development_dependency 'minitest', '~> 5.11'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'

end
