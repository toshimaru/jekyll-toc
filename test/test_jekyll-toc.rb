# frozen_string_literal: true

require 'test_helper'

class TestTableOfContentsFilter < Minitest::Test
  include Jekyll::TableOfContentsFilter

  DUMMY_HTML = '<div>Dummy HTML Content</div>'

  def setup
    @context = Struct.new(:registers).new(page: { "toc" => false })
  end

  def test_toc_only
    assert_empty toc_only(DUMMY_HTML)
  end

  def test_inject_anchors
    assert_equal inject_anchors(DUMMY_HTML), DUMMY_HTML
  end

  def test_toc
    assert_equal toc(DUMMY_HTML), DUMMY_HTML
  end
end
