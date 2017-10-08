require 'test_helper'

class TestKramdownList < Minitest::Test
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
    HTML

    assert_equal(expected, Kramdown::Document.new(text).to_html)
  end

  def test_kramdown_list_3
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

    def test_kramdown_list_3
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
