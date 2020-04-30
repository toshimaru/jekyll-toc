# jekyll-toc

![CI](https://github.com/toshimaru/jekyll-toc/workflows/CI/badge.svg)
[![Gem Version](https://badge.fury.io/rb/jekyll-toc.svg)](http://badge.fury.io/rb/jekyll-toc)
[![Code Climate](https://codeclimate.com/github/toshimaru/jekyll-toc/badges/gpa.svg)](https://codeclimate.com/github/toshimaru/jekyll-toc)
[![Test Coverage](https://api.codeclimate.com/v1/badges/cd56b207f327603662a1/test_coverage)](https://codeclimate.com/github/toshimaru/jekyll-toc/test_coverage)

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [1. Basic Usage](#1-basic-usage)
  - [2. Advanced Usage](#2-advanced-usage)
- [Generated HTML](#generated-html)
- [Default Configuration](#default-configuration)
- [Customization](#customization)
  - [TOC levels](#toc-levels)
  - [Skip TOC](#skip-toc)
  - [Skip TOC Section](#skip-toc-section)
  - [CSS Styling](#css-styling)
  - [Custom CSS Class](#custom-css-class)

## Installation

Add jekyll-toc plugin in your site's `Gemfile`, and run `bundle install`.

```ruby
gem 'jekyll-toc'
```

Add jekyll-toc to the `gems:` section in your site's `_config.yml`.

```yml
plugins:
  - jekyll-toc
```

Set `toc: true` in posts for which you want the TOC to appear.

```yml
---
layout: post
title: "Welcome to Jekyll!"
toc: true
---
```

## Usage

There are three Liquid filters, which can be applied to HTML content,
e.g. the Liquid variable `content` available in Jekyll's templates.

### 1. Basic Usage

#### `toc` filter

Add the `toc` filter to your site's `{{ content }}` (e.g. `_layouts/post.html`).

```liquid
{{ content | toc }}
```

This filter places the TOC directly above the content.

### 2. Advanced Usage

If you'd like separated TOC and content, you can use `{% toc %}` tag (or `toc_only` filter) and `inject_anchors` filter.

#### `{% toc %}` tag

Generates the TOC itself as described [below](#generated-html).
Mostly useful in cases where the TOC should _not_ be placed immediately
above the content but at some other place of the page, i.e. an aside.

```html
<div>
  <div id="table-of-contents">
    {% toc %}
  </div>
  <div id="markdown-content">
    {{ content }}
  </div>
</div>
```

:warning: **`{% toc %}` Tag Limitation**

`{% toc %}` can be available only in [Jekyll Posts](https://jekyllrb.com/docs/step-by-step/08-blogging/) and [Jekyll Collections](https://jekyllrb.com/docs/collections/). If you'd like to use `{% toc %}` except posts or collections, please use `toc_only` filter as described below.

```html
<div>
  <div id="table-of-contents">
    {{ content | toc_only }}
  </div>
  <div id="markdown-content">
    {{ content | inject_anchors }}
  </div>
</div>
```

#### `inject_anchors` filter

Injects HTML anchors into the content without actually outputting the TOC itself.  

They are of the form (usage of [octicons](https://github.com/primer/octicons) as icon collection):

```html
<a class="anchor" href="#heading1-1" aria-hidden="true">
  <span class="octicon octicon-link"></span>
</a>
```

They are of the form (unicode symbol):

```html
<a class="anchor" href="#heading1-1" aria-hidden="true">
  &#128279;&nbsp;
</a>
```

This is useful when the TOC itself should be placed at some other location with the `toc_only` filter.  

The second usecase is when you want to **share a link** to the page and link directly to the headline / section.  

There is a new configuration `inject_anchors_content` key, possible values are (or what you prefer)

* `&#128279;&nbsp;` (default) to add a unicode symbol (chain) for an link
* `<span class="octicon octicon-link"></span>` to use the octicon icon
* ` ` an empty string or a space is for **hide** the anchor

## Generated HTML

jekyll-toc generates an unordered list. The HTML output is as follows.

```html
<ul class="section-nav">
  <li class="toc-entry toc-h1"><a href="#heading1">Heading.1</a>
    <ul>
      <li class="toc-entry toc-h2"><a href="#heading1-1">Heading.1-1</a></li>
      <li class="toc-entry toc-h2"><a href="#heading1-2">Heading.1-2</a></li>
    </ul>
  </li>
  <li class="toc-entry toc-h1"><a href="#heading2">Heading.2</a>
    <ul>
      <li class="toc-entry toc-h2"><a href="#heading2-1">Heading.2-1</a>
        <ul>
          <li class="toc-entry toc-h3"><a href="#heading2-1-1">Heading.2-1-1</a></li>
          <li class="toc-entry toc-h3"><a href="#heading2-1-2">Heading.2-1-2</a></li>
        </ul>
      </li>
      <li class="toc-entry toc-h2"><a href="#heading2-2">Heading.2-2</a></li>
    </ul>
  </li>
</ul>
```

![screenshot](https://user-images.githubusercontent.com/803398/28401295-0dcfb7ca-6d54-11e7-892b-2f2e6ca755a7.png)

## Default Configuration 

```yml
toc:
  min_level: 1
  max_level: 6
  no_toc_section_class: no_toc_section
  list_class: section-nav
  sublist_class: ''
  item_class: toc-entry
  item_prefix: toc-
```

## Customization

### TOC levels

The toc levels can be configured on `_config.yml`:

```yml
toc:
  min_level: 2 # default: 1
  max_level: 5 # default: 6
```

The default level range is `<h1>` to `<h6>`.

### Skip TOC

The heading is ignored in the toc when you add `no_toc` to the class.

```html
<h1>h1</h1>
<h1 class="no_toc">This heading is ignored in the toc</h1>
<h2>h2</h2>
```

### Skip TOC Section

The headings are ignored inside the element which has `no_toc_section` class.

```html
<h1>h1</h1>
<div class="no_toc_section">
  <h2>This heading is ignored in the toc</h2>
  <h3>This heading is ignored in the toc</h3>
</div>
<h4>h4</h4>
```

Which would result in only the `<h1>` & `<h4>` within the example being included in the TOC.

The class can be configured on `_config.yml`:

```yml
toc:
  no_toc_section_class: exclude # default: no_toc_section
```

Configuring multiple classes for `no_toc_section_class` is allowed:

```yml
toc:
  no_toc_section_class:
    - no_toc_section
    - exclude
    - your_custom_skip_class_name
```

### CSS Styling

The toc can be modified with CSS. The sample CSS is the following.

```css
.section-nav {
  background-color: #fff;
  margin: 5px 0;
  padding: 10px 30px;
  border: 1px solid #e8e8e8;
  border-radius: 3px;
}
```

![screenshot](https://user-images.githubusercontent.com/803398/28401455-0ba60868-6d55-11e7-8159-0ae7591aee66.png)

Each TOC `li` entry has two CSS classes for further styling. The general `toc-entry` is applied to all `li` elements in the `ul.section-nav`.

Depending on the heading level each specific entry refers to, it has a second CSS class `toc-XX`, where `XX` is the HTML heading tag name. For example, the TOC entry linking to a heading `<h1>...</h1>` (a single
`#` in Markdown) will get the CSS class `toc-h1`.

### Custom CSS Class

You can apply custom CSS classes to the generated `<ul>` and `<li>` tags.

```yml
toc:
  # Default is "section-nav":
  list_class: my-list-class
  # Default is no class for sublists:
  sublist_class: my-sublist-class
  # Default is "toc-entry":
  item_class: my-item-class
  # Default is "toc-":
  item_prefix: item-
```
