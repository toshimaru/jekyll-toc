# frozen_string_literal: true

require 'test_helper'

class TestOrderedList < Minitest::Test
  include TestHelpers

  def test_default_configuration
    configuration = Jekyll::TableOfContents::Configuration.new({})

    refute(configuration.ordered_list)
  end

  def test_disabled_ordered_list
    configuration = Jekyll::TableOfContents::Configuration.new('ordered_list' => false)

    refute(configuration.ordered_list)
  end

  def test_enabled_ordered_list
    configuration = Jekyll::TableOfContents::Configuration.new('ordered_list' => true)

    assert(configuration.ordered_list)
  end

  def test_basic_ordered_list_top_heading
    parse_with_ordered_list
    html = @parser.toc

    assert_match(/^<ol id="toc" class="section-nav">/, html)
  end

  def test_ordered_list_sub_headings
    parse_with_ordered_list
    html = @parser.toc

    assert_match(/<ol>\n<li class="toc-entry/, html)
  end

  def test_ordered_list_top_heading_with_classes
    parse_with_ordered_list_and_classes
    html = @parser.toc

    assert_match(/^<ol id="toc" class="top-list-class">/, html)
  end

  def test_ordered_list_sub_headings_with_classes
    parse_with_ordered_list_and_classes
    html = @parser.toc

    assert_match(/<ol class="sublist-class">/, html)
  end

  def test_ordered_list_subheadings_with_classes_nested_structure
    parse_with_ordered_list_and_classes
    html = @parser.toc

    occurrences = html.scan(/<ol class="sublist-class">/).count

    assert_equal(5, occurrences)
  end

  private

  def parse_with_ordered_list
    read_html_and_create_parser('ordered_list' => true)
  end

  def parse_with_ordered_list_and_classes
    read_html_and_create_parser(
      'ordered_list' => true,
      'list_class' => 'top-list-class',
      'sublist_class' => 'sublist-class'
    )
  end
end
