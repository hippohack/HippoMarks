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

    # doc = Nokogiri::HTML.fragment(file.read)
    # TODO: どうせなら抽象化して全部整形する
    result = file.read.gsub(/<DT>(<A|<H3).+(<\/A>|<\/H3>)/) do |match|
      match += '</DT>'
    end
    doc = Nokogiri::HTML.parse(result)

    doc.xpath('/html/body/dl/dl').each do |dl|
      dl.xpath('./dt').each do |item|
        Bookmark.save_import_data(item, 1, account)
      end
    end

    true
  end
end
