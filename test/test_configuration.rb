# frozen_string_literal: true

require 'test_helper'

class TestConfiguration < Minitest::Test
  def test_default_conf1guration
    configuration = Jekyll::TableOfContents::Configuration.new({})

    assert_equal configuration.toc_levels, 1..6
    assert_equal configuration.no_toc_section_class, 'no_toc_section'
    assert_equal configuration.list_class, 'section-nav'
    assert_equal configuration.list_id, 'toc'
    assert_equal configuration.sublist_class, ''
    assert_equal configuration.item_class, 'toc-entry'
    assert_equal configuration.item_prefix, 'toc-'
    assert_equal configuration.inject_anchors_content, '&#128279;&nbsp;'
  end

  def test_type_error
    configuration = Jekyll::TableOfContents::Configuration.new('TypeError!')

    assert_equal configuration.toc_levels, 1..6
    assert_equal configuration.no_toc_section_class, 'no_toc_section'
    assert_equal configuration.list_class, 'section-nav'
    assert_equal configuration.list_id, 'toc'
    assert_equal configuration.sublist_class, ''
    assert_equal configuration.item_class, 'toc-entry'
    assert_equal configuration.item_prefix, 'toc-'
    assert_equal configuration.inject_anchors_content, '&#128279;&nbsp;'
  end
end