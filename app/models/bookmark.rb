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

    doc = Nokogiri::HTML.parse(file.read)

    doc.xpath('/html/body/dl/dl').each do |dl|
      dl.xpath('./dt').each do |item|
        Bookmark.save_import_data(item, 1, account)
      end
    end

    true
  end
end
