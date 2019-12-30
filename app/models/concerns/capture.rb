require 'active_support/concern'
require 'selenium-webdriver'
require 'rmagick'

# site capture with 'watir'
module Capture
  extend ActiveSupport::Concern

  included do
    # configure the driver to run in headless mode
    @webdriver_options = Selenium::WebDriver::Chrome::Options.new
    @webdriver_options.add_argument('--headless')
    @webdriver_options.add_argument('--no-sandbox')
    @webdriver_options.add_argument('--disable-gpu')
    @webdriver_options.add_argument('--hide-scrollbars')
    @webdriver_options.binary = '/usr/bin/google-chrome'
  end

  class_methods do
    def get_screenshot(url)
      driver = Selenium::WebDriver.for :chrome, options: @webdriver_options

      begin
        driver.navigate.to url
        driver.manage.window.resize_to(1280, 800)
        src = driver.screenshot_as(:base64)
      rescue => exception
        puts exception
        return nil
      end

      # resize the window and take a screenshot
      driver.quit

      'data:image/png;base64,' + Base64.encode64(img_resize(src).to_blob)
    end

    # to '372x248'
    def img_resize(src)
      image = Magick::Image.from_blob(Base64.decode64(src)).first
      new_src = image.change_geometry!('372x248') do |cols, rows, img|
        img.resize(cols, rows)
      end
      new_src
    end

    def img_to_base64(file_path)
      image = Magick::Image.from_blob(File.open(file_path).read).first
      new_src = image.change_geometry!('372x248') do |cols, rows, img|
        img.resize(cols, rows)
      end
      'data:image/png;base64,' + Base64.encode64(new_src.to_blob)
    end
  end
end
