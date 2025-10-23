# frozen_string_literal: true

require 'test_helper'

class TestTocOnlyDirectText < Minitest::Test
  def test_default_includes_nested_elements
    html = '<h1>formatName <wa-tag>Required</wa-tag></h1>'
    parser = Jekyll::TableOfContents::Parser.new(html)
    toc_html = parser.build_toc

    assert_includes(toc_html, 'formatName Required')
  end

  def test_toc_only_direct_text_excludes_all_elements
    html = '<h1>formatName <wa-tag>Required</wa-tag></h1>'
    parser = Jekyll::TableOfContents::Parser.new(html, 'toc_only_direct_text' => true)
    toc_html = parser.build_toc

    assert_includes(toc_html, 'formatName')
    refute_includes(toc_html, 'Required')
  end

  def test_multiple_text_nodes_with_proper_spacing
    html = '<h2>Text before <span>element</span> text after</h2>'
    parser = Jekyll::TableOfContents::Parser.new(html, 'toc_only_direct_text' => true)
    toc_html = parser.build_toc

    assert_includes(toc_html, 'Text before text after')
    refute_includes(toc_html, 'element')
  end

  def test_web_awesome_components
    html = <<~HTML
      <h1>formatName <wa-tag>Required</wa-tag></h1>
      <h2>iconName <wa-badge>New</wa-badge></h2>
      <h3>displayName <wa-icon>star</wa-icon></h3>
    HTML

    parser = Jekyll::TableOfContents::Parser.new(html, 'toc_only_direct_text' => true)
    toc_html = parser.build_toc

    assert_includes(toc_html, 'formatName')
    refute_includes(toc_html, 'Required')
    assert_includes(toc_html, 'iconName')
    refute_includes(toc_html, 'New')
    assert_includes(toc_html, 'displayName')
    refute_includes(toc_html, 'star')
  end

  def test_various_element_types
    html = <<~HTML
      <h1>Title with <code>code</code> element</h1>
      <h2>Title with <span>span</span> element</h2>
      <h3>Title with <strong>strong</strong> element</h3>
      <h4>Title with <em>emphasis</em> element</h4>
      <h5>Title with <badge>badge</badge> element</h5>
    HTML

    parser = Jekyll::TableOfContents::Parser.new(html, 'toc_only_direct_text' => true)
    toc_html = parser.build_toc

    assert_includes(toc_html, 'Title with')
    refute_includes(toc_html, 'code')
    refute_includes(toc_html, 'span')
    refute_includes(toc_html, 'strong')
    refute_includes(toc_html, 'emphasis')
    refute_includes(toc_html, 'badge')
  end

  def test_heading_with_only_nested_content
    html = '<h1><span>Only Nested Content</span></h1>'
    parser = Jekyll::TableOfContents::Parser.new(html, 'toc_only_direct_text' => true)
    toc_html = parser.build_toc

    # When there's no direct text, we should get an empty TOC entry or handle gracefully
    refute_includes(toc_html, 'Only Nested Content')
  end
end
