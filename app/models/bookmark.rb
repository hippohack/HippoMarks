class Bookmark < ApplicationRecord
  belongs_to :account
  belongs_to :folder

  validates :url, presence: true

  include Import

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
end
