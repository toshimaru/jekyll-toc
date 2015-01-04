# This plugin is still WIP.

[![Gem Version](https://badge.fury.io/rb/jekyll-toc.svg)](http://badge.fury.io/rb/jekyll-toc)
[![Dependency Status](https://gemnasium.com/toshimaru/jekyll-toc.svg)](https://gemnasium.com/toshimaru/jekyll-toc)
[![Code Climate](https://codeclimate.com/github/toshimaru/jekyll-toc/badges/gpa.svg)](https://codeclimate.com/github/toshimaru/jekyll-toc)

## TODO
* Test
* Travis CI
* Coverage & Coverall

# Imprementation idea

## page filter
```
{{ page | toc }}
```

* Customisable
+ Keep `content` clean (no filter for content)

## content filter
```
{{ content | toc }}
```

or

```
{{ content | toc: use_toc? }}
```

* Uncustomisable
* need to pass in option of whether to use toc
