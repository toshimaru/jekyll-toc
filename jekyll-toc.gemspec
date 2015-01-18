lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "version"

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-toc'
  spec.version       = JekyllToc::VERSION
  spec.summary       = "Jekyll Table of Contents plugin"
  spec.description   = "Jekyll plugin which generates a table of contents at the top of the content"
  spec.authors       = ["Toshimaru"]
  spec.email         = 'me@toshimaru.net'
  spec.files         = `git ls-files -z`.split("\x0")
  spec.homepage      = 'https://github.com/toshimaru/jekyll-toc'
  spec.license       = 'MIT'
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "nokogiri", "~> 1.6"
  spec.add_development_dependency 'minitest', "~> 5.0"
  spec.add_development_dependency "jekyll", "~> 2.0"
  spec.add_development_dependency "rake"
end
