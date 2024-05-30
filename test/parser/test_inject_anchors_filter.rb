# frozen_string_literal: true

require 'test_helper'

class TestInjectAnchorsFilter < Minitest::Test
  include TestHelpers

  def setup
    read_html_and_create_parser
  end

  def test_injects_anchors_into_content
    html = @parser.inject_anchors_into_html
    #puts "START OF HTML #{html} END OF HTML IN TEST"
    
    (1..6).each do |level|
      assert_match(
        %r{<h#{level}><a class="anchor" href="#simple-h#{level}" aria-hidden="true"><span class="octicon octicon-link"></span>Simple H#{level}</a></h#{level}>},
        html
      )
    end
  end

  def test_does_not_inject_toc
    html = @parser.inject_anchors_into_html

    refute_includes(html, %(<ul id="toc" class="section-nav">))
  end
end
