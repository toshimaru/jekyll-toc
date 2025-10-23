# frozen_string_literal: true

require 'test_helper'

class TestPageConfigOverride < Minitest::Test
  include Liquid

  def setup
    @stubbed_context  = Struct.new(:registers)
    @stubbed_context1 = Struct.new(:config)
    @stubbed_context2 = Struct.new(:toc, :content, :toc_config)
  end

  def test_page_overrides_min_level
    # Site config has min_level: 1, max_level: 6
    # Page config overrides to min_level: 2
    html_content = '<h1>H1 Title</h1><h2>H2 Title</h2><h3>H3 Title</h3>'

    context = @stubbed_context.new({
                                     page: @stubbed_context2.new(
                                       true,
                                       html_content,
                                       { 'min_level' => 2 }
                                     ),
                                     site: @stubbed_context1.new({
                                                                   'toc' => { 'min_level' => 1, 'max_level' => 6 }
                                                                 })
                                   })

    tag = Jekyll::TocTag.parse('toc_tag', '', Tokenizer.new(''), ParseContext.new)
    result = tag.render(context)

    # H1 should not be in TOC due to min_level override
    refute_match(/H1 Title/, result)
    # H2 and H3 should be in TOC
    assert_match(/H2 Title/, result)
    assert_match(/H3 Title/, result)
  end

  def test_page_overrides_max_level
    # Site config has min_level: 1, max_level: 6
    # Page config overrides to max_level: 2
    html_content = '<h1>H1 Title</h1><h2>H2 Title</h2><h3>H3 Title</h3>'

    context = @stubbed_context.new({
                                     page: @stubbed_context2.new(
                                       true,
                                       html_content,
                                       { 'max_level' => 2 }
                                     ),
                                     site: @stubbed_context1.new({
                                                                   'toc' => { 'min_level' => 1, 'max_level' => 6 }
                                                                 })
                                   })

    tag = Jekyll::TocTag.parse('toc_tag', '', Tokenizer.new(''), ParseContext.new)
    result = tag.render(context)

    # H1 and H2 should be in TOC
    assert_match(/H1 Title/, result)
    assert_match(/H2 Title/, result)
    # H3 should not be in TOC due to max_level override
    refute_match(/H3 Title/, result)
  end

  def test_page_overrides_both_min_and_max_level
    # Page config overrides both min and max level to show only H2
    html_content = '<h1>H1 Title</h1><h2>H2 Title</h2><h3>H3 Title</h3>'

    context = @stubbed_context.new({
                                     page: @stubbed_context2.new(
                                       true,
                                       html_content,
                                       { 'min_level' => 2, 'max_level' => 2 }
                                     ),
                                     site: @stubbed_context1.new({
                                                                   'toc' => { 'min_level' => 1, 'max_level' => 6 }
                                                                 })
                                   })

    tag = Jekyll::TocTag.parse('toc_tag', '', Tokenizer.new(''), ParseContext.new)
    result = tag.render(context)

    # Only H2 should be in TOC
    refute_match(/H1 Title/, result)
    assert_match(/H2 Title/, result)
    refute_match(/H3 Title/, result)
  end

  def test_no_page_config_uses_site_config
    # When no page config is provided, use site defaults
    html_content = '<h1>H1 Title</h1><h2>H2 Title</h2>'

    context = @stubbed_context.new({
                                     page: @stubbed_context2.new(
                                       true,
                                       html_content,
                                       nil # no page config
                                     ),
                                     site: @stubbed_context1.new({
                                                                   'toc' => { 'min_level' => 1, 'max_level' => 6 }
                                                                 })
                                   })

    tag = Jekyll::TocTag.parse('toc_tag', '', Tokenizer.new(''), ParseContext.new)
    result = tag.render(context)

    # Both H1 and H2 should be in TOC with site defaults
    assert_match(/H1 Title/, result)
    assert_match(/H2 Title/, result)
  end

  def test_page_config_with_other_options
    # Page can override min/max level while keeping other site config
    html_content = '<h2>H2 Title</h2><h3>H3 Title</h3>'

    context = @stubbed_context.new({
                                     page: @stubbed_context2.new(
                                       true,
                                       html_content,
                                       { 'min_level' => 2, 'max_level' => 3 }
                                     ),
                                     site: @stubbed_context1.new({
                                                                   'toc' => {
                                                                     'min_level' => 1,
                                                                     'max_level' => 6,
                                                                     'list_class' => 'custom-toc'
                                                                   }
                                                                 })
                                   })

    tag = Jekyll::TocTag.parse('toc_tag', '', Tokenizer.new(''), ParseContext.new)
    result = tag.render(context)

    # Should use page's min/max levels but keep site's list_class
    assert_match(/H2 Title/, result)
    assert_match(/H3 Title/, result)
    assert_match(/class="custom-toc"/, result)
  end
end
