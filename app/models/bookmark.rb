require 'open-uri'

class Bookmark < ApplicationRecord
  belongs_to :account
  belongs_to :folder

  validates :url, presence: true
  validates :url, format: {
    with: /\A[a-zA-Z]+:/,
    message: 'Missing URI scheme'
  }

  ## コールバックで設定すると必要なアクションでも作動する？
  # after_commit :enque_job, on: [ :create, :update ]

  scope :histories, -> {
    where('last_access_time > ?', 0)
      .order(last_access_time: :desc)
  }

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
      # 既存のアイテムの最後のソート番号にプラス１した値からはじめる
      sort_num = last_sort_num(account.bookmarkbar_folder_id, account.id)

      dl.xpath('./dt').each do |item|
        Bookmark.save_import_data(item, 1, account, nil, sort_num)
        sort_num += 1
      end
    end

    true
  end

  def self.search(search)
    return nil if search.blank?

    where('name LIKE ?', "%#{search}%")
      .or(where('keyword LIKE ?', "%#{search}%"))
      .or(where('url LIKE ?', "%#{search}%")).distinct
  end

  def self.get_site_capture(url)
    doc = Nokogiri::HTML(self.safe_open(url))

    return nil if doc.blank?

    og_image_url = doc.xpath('/html/head/meta[@property="og:image"]/@content').to_s
    og_image_url = doc.xpath('/html/head/meta[@property="og:image:url"]/@content').to_s if og_image_url.blank?

    # httpだったらcaptureとる
    uri = URI.parse(og_image_url) if og_image_url

    if og_image_url.blank? || uri.scheme.blank? || uri.scheme != 'https'
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

  def self.get_icon(url)
    favicon = safe_open(Addressable::URI.parse(url).scheme + '://' + Addressable::URI.parse(url).host + '/favicon.ico')
    return 'data:image/png;base64,' + Base64.encode64(favicon) unless favicon.blank?

    doc = Nokogiri::HTML(safe_open(url))
    return nil if doc.blank?

    icon_url = doc.xpath('/html/head/link[@rel="shortcut icon"]/@href').to_s
    icon_url = doc.xpath('/html/head/link[@rel="icon"]/@href').to_s if icon_url.blank?
    return nil if icon_url.blank?

    'data:image/png;base64,' + Base64.encode64(safe_open(icon_url))
  end

  # FIXME: ここにあるのどうなの
  def self.last_sort_num(folder_id, account_id)
    current_account = Account.find(account_id)
    folder = current_account.folders.find(folder_id)
    folder_last = folder.folders.order(:sort_num).last
    bookmark_last = folder.bookmarks.order(:sort_num).last

    if bookmark_last.present? && folder_last.present?
      last = folder_last.sort_num < bookmark_last.sort_num ? bookmark_last : folder_last
    end

    last = bookmark_last if bookmark_last.present? && folder_last.blank?
    last = folder_last if bookmark_last.blank? && folder_last.present?

    last ? last.sort_num : -1
  end

  def add_fetch_favicon_and_capture_job
    if self.og_image_url.blank? && self.icon.blank?
      enque_job
    end
  end

  private

  def enque_job
    # get og and favicon images with job.
    CaptureJob.perform_later(self.id)
  end
end
