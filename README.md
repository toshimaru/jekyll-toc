# jekyll-toc

[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/toshimaru/jekyll-toc?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

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

## Generated Table of Contents HTML

jekyll-toc generates Unordered List. The final output is as follows.

```html
<ul class="section-nav">
  <li><a href="#heading1">Heading.1</a></li>
  <li><a href="#heading2-1">Heading.2-1</a></li>
  <li><a href="#heading2-2">Heading.2-2</a></li>
  <li><a href="#heading3">Heading.3</a></li>
  <li><a href="#heading2-3">Heading.2-3</a></li>
</ul>
```

It looks like the image below.

![screenshot](https://cloud.githubusercontent.com/assets/803398/5722561/7f59e8aa-9b80-11e4-9ee5-27a15192ee83.png)

## CSS Styling

The toc can be modified with CSS. The sample CSS is the following.

```css
.section-nav {
  background-color: #FFF;
  margin: 5px 0;
  padding: 10px 30px;
  border: 1px solid #E8E8E8;
  border-radius: 3px;
}
```

![screenshot](https://cloud.githubusercontent.com/assets/803398/5723662/f0bc84c8-9b88-11e4-986c-90608ca88184.png)

## TODO
* Test
* Travis CI
* Coverage & Coverall
* Close toc with JavaScript
