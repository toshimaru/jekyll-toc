# frozen_string_literal: true

require 'test_helper'

class TestTableOfContentsTag < Minitest::Test
  include Liquid

  def setup
    @stubbed_context  = Struct.new(:registers)
    @stubbed_context1 = Struct.new(:config)
    @stubbed_context2 = Struct.new(:toc, :content)
  end

  def test_toc_tag
    context = @stubbed_context.new(
      page: @stubbed_context2.new({ 'toc' => false }, '<h1>test</h1>'),
      site: @stubbed_context1.new({ 'toc' => nil })
    )
    tag = Jekyll::TocTag.parse('toc_tag', '', Tokenizer.new(''), ParseContext.new)
    assert_equal(%(<ul id="toc" class="section-nav">\n<li class="toc-entry toc-h1"><a href="#test">test</a></li>\n</ul>), tag.render(context))
  end

  def test_toc_tag_returns_empty_string
    context = @stubbed_context.new(page: { 'toc' => false })
    tag = Jekyll::TocTag.parse('toc_tag', '', Tokenizer.new(''), ParseContext.new)
    assert_empty tag.render(context)
  end
end
