# -*- ruby -*-
#
# Copyright (C) 2012  Kouhei Sutou <kou@clear-code.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

require "test-unit-capybara-test-utils"

class AssertionsTest < Test::Unit::TestCase
  include Capybara::DSL

  class BodyTest < self
    setup do
      Capybara.app = lambda do |environment|
        [
          200,
          {"Content-Type" => "application/json"},
          [JSON.generate({"status" => true})],
        ]
      end
    end

    def test_with_shortcut_content_type
      visit("/")
      assert_body({"status" => true}, :content_type => :json)
    end

    def test_without_content_type
      visit("/")
      assert_body({"status" => true})
    end
  end

  class AllTest < self
    setup do
      @html = <<-HTML
<html>
  <body>
    <h1>Hello</h1>
    <h2>Yay!</h2>
    <div class="section">
      <h2>World</h2>
    </div>
  </body>
</html>
HTML
      Capybara.app = lambda do |environment|
        [
          200,
          {"Content-Type" => "text/html"},
          [@html],
        ]
      end
    end

    def test_no_kind
      visit("/")
      h2s = assert_all("h2")
      assert_equal(["Yay!", "World"], h2s.collect(&:text))
    end

    def test_css
      visit("/")
      h2s = assert_all(:css, "h2")
      assert_equal(["Yay!", "World"], h2s.collect(&:text))
    end

    def test_xpath
      visit("/")
      h2s = assert_all(:xpath, "//h2")
      assert_equal(["Yay!", "World"], h2s.collect(&:text))
    end

    def test_node
      visit("/")
      section = find("div.section")
      h2s = assert_all(section, "h2")
      assert_equal(["World"], h2s.collect(&:text))
    end

    def test_fail_no_context
      visit("/")
      message = <<-EOM.strip
<"h3">(:css) expected to find one or more elements in
<#{@html}>
EOM
      exception = Test::Unit::AssertionFailedError.new(message)
      assert_raise(exception) do
        assert_all("h3")
      end
    end

    def test_fail_in_context
      visit("/")
      section_html = @html.scan(/<div class="section">.*?<\/div>/m)[0]
      message = <<-EOM.strip
<"h1">(:css) expected to find one or more elements in
<#{section_html}>
EOM
      exception = Test::Unit::AssertionFailedError.new(message)
      within("div.section") do
        assert_raise(exception) do
          assert_all("h1")
        end
      end
    end
  end

  class NotFindTest < self
    setup do
      @html = <<-HTML
<html>
  <body>
    <h1>Hello</h1>
    <h2>Yay!</h2>
    <div class="section">
      <h2>World</h2>
    </div>
  </body>
</html>
HTML
      Capybara.app = lambda do |environment|
        [
          200,
          {"Content-Type" => "text/html"},
          [@html],
        ]
      end
    end

    class WithoutNodeTest < self
      def test_no_kind
        visit("/")
        assert_not_find("h3")
      end

      def test_css
        visit("/")
        assert_not_find(:css, "h3")
      end

      def test_xpath
        visit("/")
        assert_not_find(:xpath, "//h3")
      end

      def test_block
        visit("/")
        within("div.section") do
          assert_not_find("h3")
        end
      end

      def test_fail_no_context
        visit("/")
        h1_html = @html.scan(/<h1>.*?<\/h1>/m)[0]
        message = <<-EOM.strip
<"h1">(:css) expected to not find a element but was
<#{h1_html}> in
<#{@html}>
EOM
        exception = Test::Unit::AssertionFailedError.new(message)
        assert_raise(exception) do
          assert_not_find("h1")
        end
      end

      def test_fail_in_context
        visit("/")
        section_html = @html.scan(/<div class="section">.*?<\/div>/m)[0]
        h2_in_section_html = section_html.scan(/<h2>.*?<\/h2>/m)[0]
        message = <<-EOM.strip
<"h2">(:css) expected to not find a element but was
<#{h2_in_section_html}> in
<#{section_html}>
EOM
        exception = Test::Unit::AssertionFailedError.new(message)
        within("div.section") do
          assert_raise(exception) do
            assert_not_find("h2")
          end
        end
      end
    end

    class WithNodeTest < self
      def test_no_kind
        visit("/")
        section = find("div.section")
        assert_not_find(section, "h1")
      end

      def test_css
        visit("/")
        section = find("div.section")
        assert_not_find(section, :css, "h1")
      end

      def test_xpath
        visit("/")
        section = find("div.section")
        assert_not_find(section, :xpath, ".//h1")
      end

      def test_fail
        visit("/")
        section = find("div.section")
        section_html = @html.scan(/<div class="section">.*?<\/div>/m)[0]
        h2_html = section_html.scan(/<h2>.*?<\/h2>/m)[0]
        message = <<-EOM.strip
<"h2">(:css) expected to not find a element but was
<#{h2_html}> in
<#{section_html}>
EOM
        exception = Test::Unit::AssertionFailedError.new(message)
        assert_raise(exception) do
          assert_not_find(section, "h2")
        end
      end
    end
  end

  class InspectorTest < self
    setup do
      @html = <<-HTML
<html>
  <body>
    <h1>Hello</h1>
    <h2>Yay!</h2>
    <div class="section">
      <h2>World</h2>
    </div>
  </body>
</html>
HTML
      Capybara.app = lambda do |environment|
        [
          200,
          {"Content-Type" => "text/html"},
          [@html],
        ]
      end
    end

    def test_pretty_print
      visit("/")
      section_html = @html.scan(/<div class="section">.*?<\/div>/m)[0]
      element_class = find("html").class
      message = <<-EOM.strip
<"XXX"> expected but was
<\#<#{element_class} tag="div" path="/html/body/div"
#{section_html}>>.

diff:
- "XXX"
+ \#<#{element_class} tag="div" path="/html/body/div"
+ <div class="section">
+       <h2>World</h2>
+     </div>>
EOM
      exception = Test::Unit::AssertionFailedError.new(message)
      assert_raise(exception) do
        assert_equal("XXX", find("div.section"))
      end
    end
  end
end
