# frozen_string_literal: true

require_relative 'lib/table_of_contents/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-toc'
  spec.version       = Jekyll::TableOfContents::VERSION
  spec.summary       = 'Jekyll Table of Contents plugin'
  spec.description   = 'Jekyll (Ruby static website generator) plugin which generates a Table of Contents for the page.'
  spec.authors       = %w[toshimaru torbjoernk]
  spec.email         = 'me@toshimaru.net'
  spec.homepage      = 'https://github.com/toshimaru/jekyll-toc'
  spec.license       = 'MIT'
  spec.require_paths = ['lib']

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/toshimaru/jekyll-toc'
  spec.metadata['changelog_uri'] = 'https://github.com/toshimaru/jekyll-toc/releases'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end

  spec.required_ruby_version = '>= 2.6'

  spec.add_dependency 'jekyll', '>= 3.9'
  spec.add_dependency 'nokogiri', '~> 1.12'
end
