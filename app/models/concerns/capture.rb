require 'active_support/concern'
require 'selenium-webdriver'
require 'rmagick'

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
      options.add_argument('--hide-scrollbars')

      driver = Selenium::WebDriver.for :chrome, options: options

      driver.navigate.to url

      # resize the window and take a screenshot
      driver.manage.window.resize_to(1280, 800)
      src = driver.screenshot_as(:base64)
      driver.quit

      image = Magick::Image.from_blob(Base64.decode64(src)).first
      new_src = image.change_geometry!('372x248') do |cols, rows, img|
        img.resize(cols, rows)
      end

      'data:image/png;base64,' + Base64.encode64(new_src.to_blob)
    end
  end
end
