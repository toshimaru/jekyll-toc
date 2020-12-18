# frozen_string_literal: true

require 'test_helper'

class TestConfiguration < Minitest::Test
  def test_default_configuration
    configuration = Jekyll::TableOfContents::Configuration.new({})

    assert_equal(1..6, configuration.toc_levels)
    refute(configuration.ordered_list)
    assert_equal('no_toc_section', configuration.no_toc_section_class)
    assert_equal('toc', configuration.list_id)
    assert_equal('section-nav', configuration.list_class)
    assert_equal('', configuration.sublist_class)
    assert_equal('toc-entry', configuration.item_class)
    assert_equal('toc-', configuration.item_prefix)
  end

  def test_type_error
    configuration = Jekyll::TableOfContents::Configuration.new('TypeError!')

    assert_equal(1..6, configuration.toc_levels)
    refute(configuration.ordered_list)
    assert_equal('no_toc_section', configuration.no_toc_section_class)
    assert_equal('toc', configuration.list_id)
    assert_equal('section-nav', configuration.list_class)
    assert_equal('', configuration.sublist_class)
    assert_equal('toc-entry', configuration.item_class)
    assert_equal('toc-', configuration.item_prefix)
  end
end
