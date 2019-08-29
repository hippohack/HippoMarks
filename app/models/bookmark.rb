require 'open-uri'

class Bookmark < ApplicationRecord
  belongs_to :account
  belongs_to :folder

  validates :url, presence: true

  include Import
  include Capture

  def self.get_child_bookmarks(bookmark_id)
    self.where(parent_id: bookmark_id)
  end

  def self.import(file, account)
    raise unless file.content_type == "text/html"

    # タグの不完全な部分を調整
    # TODO: どうせなら抽象化して全部整形する
    result = file.read.gsub(/<DT><A[.\s\S]*?">[.\s\S]*?<\/A>/) do |match|
      match += '</DT>'
    end
    result = result.gsub(/<\/DL>[\s]*<p>/) do |match|
      match = "</DL></DT>"
    end
    # raise
    doc = Nokogiri::HTML.parse(result)

    doc.xpath('/html/body/dl').each do |dl|
    # doc.xpath('/html/body/dl/dl').each do |dl|
      dl.xpath('./dt').each do |item|
        Bookmark.save_import_data(item, 1, account)
      end
    end

    true
  end

  def self.search(search)
    return nil if search.blank?
    where('name LIKE ?', "%#{search}%").or(where('keyword LIKE ?', "%#{search}%")).distinct
  end

  def self.get_site_capture(url)
    doc = Nokogiri::HTML(self.safe_open(url))

    return nil if doc.blank?

    # <meta property=”og:image” content=”http://www.yourdomain.com/image-name.jpg” />
    og_image_url = doc.xpath('/html/head/meta[@property="og:image"]/@content').to_s
    og_image_url = doc.xpath('/html/head/meta[@property="og:image:url"]/@content').to_s if og_image_url.blank?

    if og_image_url.blank?
      # TODO: capture site image
      og_image_url = Bookmark.get_screenshot(url)
    end

    og_image_url
  end

  def self.safe_open(url)
    begin
      OpenURI.open_uri(url, redirect: false) { |io|
        return io.read
      }
    rescue => e
      puts e # 例外メッセージ表示
    end
  end
end
