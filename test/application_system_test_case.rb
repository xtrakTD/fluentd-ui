require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # For debugging JavaScript, make slower tests...
  # caps = Selenium::WebDriver::Remote::Capabilities.chrome(loggingPrefs: { browser: 'ALL' })
  # Add `options: { desired_capabilities: caps }` and then paste `pp page.driver.browser.manage.logs.get(:browser)`
  driven_by :selenium, using: :headless_chrome, screen_size: [1920, 1080]
end
