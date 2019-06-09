class Bookmark < ApplicationRecord
  belongs_to :account
  belongs_to :folder

  validates :name, presence: true
  validates :url, presence: true

  def self.get_child_bookmarks(bookmark_id)
    self.where(parent_id: bookmark_id)
  end
end
