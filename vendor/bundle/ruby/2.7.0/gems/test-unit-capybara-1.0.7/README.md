# test-unit-capybara

[Web site](https://github.com/test-unit/test-unit-capybara)

## Description

test-unit-capybara is a Capybara adapter for test-unit 2. You can get [Capybara](https://rubygems.org/gems/capybara) integrated Test::Unit::TestCase. It also provides useful assertions for Capybara.

## Install

```
% sudo gem install test-unit-capybara
```

## Usage

```ruby
require 'test/unit/capybara'

class MyRackApplication
  def call(env)
    html = <<-HTML
<html>
  <head>
    <title>Welcome! - my site</title>
  </head>
  <body>
    <h1>Welcome!</h1>
    <div class="header">
      <p>No navigation.</p>
    </div>
  </body>
</html>
HTML
   [200, {"Content-Type" => "text/html"}, [html]]
  end
end

class TestMyRackApplication < Test::Unit::TestCase
  include Capybara::DSL

  def setup
    Capybara.app = MyRackApplication.new
  end

  def test_title
    visit("/")
    within("h1") do
      assert_equal("Welcome!", text)
    end
  end

  def test_no_sidebar
    visit("/")
    within("body") do
      assert_not_find(".sidebar")
    end
  end

  def test_header_content
    visit("/")
    within(".header") do
      find("ol.navi")
      # This fails with the following message:
      #
      # <"ol.navi">(:css) expected to find a element in
      # <<div class="header">
      #       <p>No navigation.</p>
      #     </div>>
      #
      # This messages shows the current context. You don't need to
      # entire HTML. You just see the current context moved by "within".
      # It helps you debug a problem without save_and_open_page.
    end
  end

  attribute :js, true
  def test_destroy_a_post
    # JavaScript driver is used
    visit("/")
    page.accept_confirm do
      click_on("Destroy", match: :first)
    end

    within(".alert") do
      assert_equal("Post was successfully destroyed", text)
    end
  end
end
```

## License

LGPLv2.1 or later.

(Kouhei Sutou has a right to change the license including contributed patches.)

## Authors

* Kouhei Sutou
