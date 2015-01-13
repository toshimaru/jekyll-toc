# This plugin is still WIP.

[![Gem Version](https://badge.fury.io/rb/jekyll-toc.svg)](http://badge.fury.io/rb/jekyll-toc)
[![Dependency Status](https://gemnasium.com/toshimaru/jekyll-toc.svg)](https://gemnasium.com/toshimaru/jekyll-toc)
[![Code Climate](https://codeclimate.com/github/toshimaru/jekyll-toc/badges/gpa.svg)](https://codeclimate.com/github/toshimaru/jekyll-toc)

![screenshot](https://cloud.githubusercontent.com/assets/803398/5722561/7f59e8aa-9b80-11e4-9ee5-27a15192ee83.png)

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

Add `toc` filter to your site's `{{ content }}` (e.g. `_layouts/post.html`).

```
{{ content | toc }}
```

Set `toc: true` in your posts.

```yml
---
layout: post
title: "Welcome to Jekyll!"
toc: true
---
```

## Generated table of Contents

```html
<ul class="section-nav">
  <li><a href="#heading1">Heading.1</a></li>
  <li><a href="#heading2-1">Heading.2-1</a></li>
  <li><a href="#heading2-2">Heading.2-2</a></li>
  <li><a href="#heading3">Heading.3</a></li>
  <li><a href="#heading2-3">Heading.2-3</a></li>
</ul>
```

## SASS Styling

```css
section-nav {

}
```

## TODO
* more README
* Test
* Travis CI
* Coverage & Coverall
* Close toc with JavaScript
