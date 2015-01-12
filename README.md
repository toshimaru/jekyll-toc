# This plugin is still WIP.

[![Gem Version](https://badge.fury.io/rb/jekyll-toc.svg)](http://badge.fury.io/rb/jekyll-toc)
[![Dependency Status](https://gemnasium.com/toshimaru/jekyll-toc.svg)](https://gemnasium.com/toshimaru/jekyll-toc)
[![Code Climate](https://codeclimate.com/github/toshimaru/jekyll-toc/badges/gpa.svg)](https://codeclimate.com/github/toshimaru/jekyll-toc)

# Usage

Add jekyll-toc plugin in your site's `Gemfile`.

```ruby
gem 'jekyll-toc'
```

And add the jekyll-toc to your site's `_config.yml`.

```yml
gems:
  - jekyll-toc
```

Finally, add `toc` filter to your site's `{{ content }}`.

```
{{ content | toc }}
```

## Generated Tablle of Contents

```html
<ul>
  <li>foo</li>
  <li>bar</li>
</ul>
```

## CSS Styling

## TODO
* more README
* Close toc JavaScript
* Test
* Travis CI
* Coverage & Coverall
