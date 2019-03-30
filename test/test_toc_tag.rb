# frozen_string_literal: true

require 'test_helper'

class TestTableOfContentsTag < Minitest::Test
  include Liquid

  def setup
    stubbed_context = Struct.new(:registers)
    @context = stubbed_context.new(page: 'xxx')
  end

  def test_toc_tag
    tag = Jekyll::TocTag.parse('toc_tag', '', Tokenizer.new(''), ParseContext.new)
    assert_empty tag.render(@context)
  end
end
