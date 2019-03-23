lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-toc'
  spec.version       = JekyllToc::VERSION
  spec.summary       = 'Jekyll Table of Contents plugin'
  spec.description   = 'A liquid filter plugin for Jekyll which generates a table of contents.'
  spec.authors       = %w(toshimaru torbjoernk)
  spec.email         = 'me@toshimaru.net'
  spec.files         = `git ls-files -z`.split("\x0")
  spec.homepage      = 'https://github.com/toshimaru/jekyll-toc'
  spec.license       = 'MIT'
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3'

  spec.add_runtime_dependency 'nokogiri', '~> 1.9'

  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'jekyll', '>= 3.5'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
end
