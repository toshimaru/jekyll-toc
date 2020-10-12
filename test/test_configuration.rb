# frozen_string_literal: true

require 'test_helper'

class TestConfiguration < Minitest::Test
  def test_default_configuration
    configuration = Jekyll::TableOfContents::Configuration.new({})

    assert_equal configuration.toc_levels, 1..6
    assert_equal configuration.no_toc_section_class, 'no_toc_section'
    assert_equal configuration.list_class, 'section-nav'
    assert_equal configuration.sublist_class, ''
    assert_equal configuration.item_class, 'toc-entry'
    assert_equal configuration.item_prefix, 'toc-'
    assert_equal configuration.ordered_list, false
  end

  def test_type_error
    configuration = Jekyll::TableOfContents::Configuration.new('TypeError!')

    assert_equal configuration.toc_levels, 1..6
    assert_equal configuration.no_toc_section_class, 'no_toc_section'
    assert_equal configuration.list_class, 'section-nav'
    assert_equal configuration.sublist_class, ''
    assert_equal configuration.item_class, 'toc-entry'
    assert_equal configuration.item_prefix, 'toc-'
    assert_equal configuration.ordered_list, false
  end
end
