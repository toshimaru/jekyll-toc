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

  spec.post_install_message = %q(As of jekyll-toc 0.3, nested toc is supported! Please make sure your toc is not broken after update jekyll-toc.

For more info: https://github.com/toshimaru/jekyll-toc/wiki/0.3-Upgrade-Guide)

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_runtime_dependency 'nokogiri', '~> 1.6'

  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 1.0'
  spec.add_development_dependency 'jekyll', '>= 3.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
end
