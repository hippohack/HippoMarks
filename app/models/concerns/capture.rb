require 'active_support/concern'
require "selenium-webdriver"

# site capture with 'watir'
module Capture
  extend ActiveSupport::Concern

  class_methods do
    def get_screenshot(url)
      # configure the driver to run in headless mode
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-gpu')
      driver = Selenium::WebDriver.for :chrome, options: options

      driver.navigate.to url

      # resize the window and take a screenshot
      # TODO: ウィンドウサイズではなく画像サイズを小さくする
      # TODO: スクロールバーなくす
      driver.manage.window.resize_to(372, 248)
      src = 'data:image/png;base64,' + driver.screenshot_as(:base64)
      # driver.save_screenshot "screenshot.png"
      src
    end
  end
end
