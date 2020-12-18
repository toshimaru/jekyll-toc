# frozen_string_literal: true

require 'test_helper'

class TestTableOfContentsFilter < Minitest::Test
  include Jekyll::TableOfContentsFilter

  DUMMY_HTML = '<div>Dummy HTML Content</div>'

  def test_toc_only
    @context = disable_toc_context
    assert_empty toc_only(DUMMY_HTML)
  end

  def test_inject_anchors
    @context = disable_toc_context
    assert_equal DUMMY_HTML, inject_anchors(DUMMY_HTML)
  end

  def test_toc
    @context = disable_toc_context
    assert_equal DUMMY_HTML, toc(DUMMY_HTML)
  end

  def test_toc_only2
    @context = enable_toc_context
    assert_equal %(<ul id="toc" class="section-nav">\n</ul>), toc_only(DUMMY_HTML)
  end

  def test_inject_anchors2
    @context = enable_toc_context
    assert_equal DUMMY_HTML, inject_anchors(DUMMY_HTML)
  end

  def test_toc2
    @context = enable_toc_context
    assert_equal %(<ul id="toc" class="section-nav">\n</ul>#{DUMMY_HTML}), toc(DUMMY_HTML)
  end

  private

  def disable_toc_context
    Struct.new(:registers).new(page: { 'toc' => false })
  end

  def enable_toc_context
    Struct.new(:registers).new(
      page: { 'toc' => true },
      site: Struct.new(:config).new({ 'toc' => false })
    )
  end
end
