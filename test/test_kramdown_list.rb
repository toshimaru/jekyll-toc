# frozen_string_literal: true

require 'test_helper'

class TestKramdownList < Minitest::Test
  # NOTE: kramdown automatically injects `id` attribute
  def test_kramdown_heading
    text = <<~MARKDOWN
      # h1

      ## h2
    MARKDOWN
    expected = <<~HTML
      <h1 id="h1">h1</h1>

      <h2 id="h2">h2</h2>
    HTML
    actual = Kramdown::Document.new(text).to_html

    assert_equal(expected, actual)
  end

  def test_japanese_heading
    text = <<~MARKDOWN
      # 日本語見出し１

      ## 日本語見出し２
    MARKDOWN
    expected = <<~HTML
      <h1 id="section">日本語見出し１</h1>

      <h2 id="section-1">日本語見出し２</h2>
    HTML
    actual = Kramdown::Document.new(text).to_html

    assert_equal(expected, actual)
  end

  def test_kramdown_list_l1_l5
    text = <<~MARKDOWN
      * level-1
        * level-2
          * level-3
            * level-4
              * level-5
    MARKDOWN
    expected = <<~HTML
      <ul>
        <li>level-1
          <ul>
            <li>level-2
              <ul>
                <li>level-3
                  <ul>
                    <li>level-4
                      <ul>
                        <li>level-5</li>
                      </ul>
                    </li>
                  </ul>
                </li>
              </ul>
            </li>
          </ul>
        </li>
      </ul>
    HTML
    actual = Kramdown::Document.new(text).to_html

    assert_equal(expected, actual)
  end

  def test_kramdown_list_l1_l3_l2_l4
    text = <<~MARKDOWN
      * level-1
          * level-3
        * level-2
            * level-4
              * level-5
    MARKDOWN
    expected = <<~HTML
      <ul>
        <li>level-1
          <ul>
            <li>level-3</li>
            <li>level-2
              <ul>
                <li>level-4
                  <ul>
                    <li>level-5</li>
                  </ul>
                </li>
              </ul>
            </li>
          </ul>
        </li>
      </ul>
    HTML
    actual = Kramdown::Document.new(text).to_html

    assert_equal(expected, actual)
  end

  def test_kramdown_list_l4_l1
    text = <<~MARKDOWN
            * level-4
          * level-3
        * level-2
      * level-1
    MARKDOWN
    expected = <<~HTML
      <pre><code>  * level-4
      * level-3   * level-2 * level-1
      </code></pre>
    HTML
    actual = Kramdown::Document.new(text).to_html

    assert_equal(expected, actual)
  end

  def test_kramdown_list_l1_l4_l1
    text = <<~MARKDOWN
      * level-1
            * level-4
          * level-3
        * level-2
      * level-1
    MARKDOWN
    expected = <<~HTML
      <ul>
        <li>level-1
          * level-4
          <ul>
            <li>level-3</li>
            <li>level-2</li>
          </ul>
        </li>
        <li>level-1</li>
      </ul>
    HTML
    actual = Kramdown::Document.new(text).to_html

    assert_equal(expected, actual)
  end

  def test_kramdown_list_l1_l3_l1
    text = <<~MARKDOWN
      * level-1
          * level-3
        * level-2
      * level-1
    MARKDOWN
    expected = <<~HTML
      <ul>
        <li>level-1
          <ul>
            <li>level-3</li>
            <li>level-2</li>
          </ul>
        </li>
        <li>level-1</li>
      </ul>
    HTML
    actual = Kramdown::Document.new(text).to_html

    assert_equal(expected, actual)
  end
end
