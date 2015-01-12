Gem::Specification.new do |spec|
  spec.name        = 'jekyll-toc'
  spec.version     = '0.0.2'
  spec.date        = '2015-01-04'
  spec.summary     = "Jekyll Table of Contents plugin"
  spec.description = "Jekyll plugin which generates a table of contents at the top of the content"
  spec.authors     = ["Toshimaru"]
  spec.email       = 'me@toshimaru.net'
  spec.files       = `git ls-files -z`.split("\x0")
  spec.homepage    = 'https://github.com/toshimaru/jekyll-toc'
  spec.license     = 'MIT'
  spec.test_files  = spec.files.grep(%r{^(test|spec|features)/})

  spec.add_runtime_dependency "nokogiri", "~> 1.6"
  spec.add_development_dependency 'minitest', "~> 5.0"
  spec.add_development_dependency "jekyll", "~> 2.0"
  spec.add_development_dependency "rake"
end
