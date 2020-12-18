# jekyll-toc

![CI](https://github.com/toshimaru/jekyll-toc/workflows/CI/badge.svg)
[![Gem Version](https://badge.fury.io/rb/jekyll-toc.svg)](https://badge.fury.io/rb/jekyll-toc)
[![Code Climate](https://codeclimate.com/github/toshimaru/jekyll-toc/badges/gpa.svg)](https://codeclimate.com/github/toshimaru/jekyll-toc)
[![Test Coverage](https://api.codeclimate.com/v1/badges/cd56b207f327603662a1/test_coverage)](https://codeclimate.com/github/toshimaru/jekyll-toc/test_coverage)

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Basic Usage](#basic-usage)
  - [Advanced Usage](#advanced-usage)
- [Generated HTML](#generated-html)
- [Customization](#customization)
  - [Default Configuration](#default-configuration)
  - [TOC levels](#toc-levels)
  - [Enable TOC by default](#enable-toc-by-default)
  - [Skip TOC](#skip-toc)
  - [Skip TOC Sectionally](#skip-toc-sectionally)
  - [CSS Styling](#css-styling)
  - [Custom CSS Class and ID](#custom-css-class-and-id)
  - [Using Unordered/Ordered lists](#using-unorderedordered-lists)
- [Alternative Tools](#alternative-tools)

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

### Basic Usage

#### `toc` filter

Add the `toc` filter to your site's `{{ content }}` (e.g. `_layouts/post.html`).

```liquid
{{ content | toc }}
```

This filter places the TOC directly above the content.

### Advanced Usage

If you'd like separated TOC and content, you can use `{% toc %}` tag (or `toc_only` filter) and `inject_anchors` filter.

#### `{% toc %}` tag / `toc_only` filter

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

`{% toc %}` works only for [Jekyll Posts](https://jekyllrb.com/docs/step-by-step/08-blogging/) and [Jekyll Collections](https://jekyllrb.com/docs/collections/).
If you'd like to use `{% toc %}` except posts or collections, please use `toc_only` filter as described below.

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
They are of the form:

```html
<a class="anchor" href="#heading1-1" aria-hidden="true">
  <span class="octicon octicon-link"></span>
</a>
```

This is only useful when the TOC itself should be placed at some other
location with the `toc_only` filter.

## Generated HTML

jekyll-toc generates an unordered list by default. The HTML output is as follows.

```html
<ul id="toc" class="section-nav">
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

## Customization

jekyll-toc is customizable on `_config.yml`.

### Default Configuration

```yml
# _config.yml
toc:
  min_level: 1
  max_level: 6
  ordered_list: false
  no_toc_section_class: no_toc_section
  list_id: toc
  list_class: section-nav
  sublist_class: ''
  item_class: toc-entry
  item_prefix: toc-
```

### TOC levels

```yml
# _config.yml
toc:
  min_level: 2 # default: 1
  max_level: 5 # default: 6
```

The default heading range is from `<h1>` to `<h6>`.

### Enable TOC by default

You can enable TOC by default with [Front Matter Defaults](https://jekyllrb.com/docs/configuration/front-matter-defaults/):

```yml
# _config.yml
defaults:
  - scope:
      path: ""
    values:
      toc: true
```

### Skip TOC

The heading is ignored in the toc by adding `no_toc` class.

```html
<h1>h1</h1>
<h1 class="no_toc">This heading is ignored in the TOC</h1>
<h2>h2</h2>
```

### Skip TOC Sectionally

The headings are ignored inside the element which has `no_toc_section` class.

```html
<h1>h1</h1>
<div class="no_toc_section">
  <h2>This heading is ignored in the TOC</h2>
  <h3>This heading is ignored in the TOC</h3>
</div>
<h4>h4</h4>
```

Which would result in only the `<h1>` & `<h4>` within the example being included in the TOC.

The class can be configured on `_config.yml`:

```yml
# _config.yml
toc:
  no_toc_section_class: exclude # default: no_toc_section
```

Configuring multiple classes are allowed:

```yml
# _config.yml
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

Depending on the heading level each specific entry refers to, it has a second CSS class `toc-XX`, where `XX` is the HTML heading tag name.
For example, the TOC entry linking to a heading `<h1>...</h1>` (a single `#` in Markdown) will get the CSS class `toc-h1`.

### Custom CSS Class and ID

You can apply custom CSS classes to the generated `<ul>` and `<li>` tags.

```yml
# _config.yml
toc:
  list_id: my-toc-id # Default: "toc"
  list_class: my-list-class # Default: "section-nav"
  sublist_class: my-sublist-class # Default: no class for sublists
  item_class: my-item-class # Default: "toc-entry"
  item_prefix: item- # Default: "toc-":
```

### Using Unordered/Ordered lists

By default the table of contents will be generated as an unordered list via `<ul></ul>` tags. This can be configured to use ordered lists instead `<ol></ol>`.
This can be configured in `_config.yml`:

```yml
# _config.yml
toc:
  ordered_list: true # default is false
```

In order to change the list type, use the [list-style-type](https://developer.mozilla.org/en-US/docs/Web/CSS/list-style-type) css property.
Add a class to the `sublist_class` configuration to append it to the `ol` tags so that you can add the `list-style-type` property.

Example

```yml
# _config.yml
toc:
  ordered_list: true
  list_class: my-list-class
  sublist_class: my-sublist-class
```

```css
.my-list-class {
  list-style-type: upper-alpha;
}

.my-sublist-class: {
  list-style-type: lower-alpha;
}
```

This will produce:

![screenshot](https://user-images.githubusercontent.com/7675276/85813980-a0ea5a80-b719-11ea-9458-ccf9b86a778b.png)

## Alternative Tools

- Adding anchor to headings
  - [AnchorJS](https://www.bryanbraun.com/anchorjs/)
- Generating TOC for kramdown content
  - [Automatic “Table of Contents” Generation](https://kramdown.gettalong.org/converter/html.html#toc) (See also. [Create Table of Contents in kramdown](https://blog.toshima.ru/2020/05/22/kramdown-toc))
