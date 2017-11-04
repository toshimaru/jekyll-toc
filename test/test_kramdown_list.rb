require 'test_helper'

class TestKramdownList < Minitest::Test
  # NOTE: kramdown automatically injects `id` attribute
  # TODO: test Japanese heading
  def test_kramdown_heading
    text = <<-MARKDOWN
# h1

## h2
    MARKDOWN
    expected = <<-HTML
<h1 id="h1">h1</h1>

<h2 id=\"h2\">h2</h2>
    HTML

    assert_equal(expected, Kramdown::Document.new(text).to_html)
  end

  def test_kramdown_list_1
    text = <<-MARKDOWN
* level-1
  * level-2
    * level-3
      * level-4
        * level-5
    MARKDOWN
    expected = <<-HTML
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

    assert_equal(expected, Kramdown::Document.new(text).to_html)
  end

  def test_kramdown_list_2
    text = <<-MARKDOWN
* level-1
    * level-3
  * level-2
      * level-4
        * level-5
    MARKDOWN
    expected = <<-HTML
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

    assert_equal(expected, Kramdown::Document.new(text).to_html)
  end

  def test_kramdown_list_3
    text = <<-MARKDOWN
      * level-4
    * level-3
  * level-2
* level-1
    MARKDOWN
    expected = <<-HTML
<pre><code>  * level-4
* level-3   * level-2 * level-1
</code></pre>
    HTML

    assert_equal(expected, Kramdown::Document.new(text).to_html)
  end

  def test_kramdown_list_4
    text = <<-MARKDOWN
* level-1
      * level-4
    * level-3
  * level-2
* level-1
    MARKDOWN
    expected = <<-HTML
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

    assert_equal(expected, Kramdown::Document.new(text).to_html)
  end

    def test_kramdown_list_5
      text = <<-MARKDOWN
* level-1
    * level-3
  * level-2
* level-1
      MARKDOWN
      expected = <<-HTML
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

      assert_equal(expected, Kramdown::Document.new(text).to_html)
    end
end
