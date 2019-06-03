class Bookmark < ApplicationRecord
  belongs_to :account
  # belongs_to :bookmarkbar_item
  has_one :url, dependent: :destroy
  accepts_nested_attributes_for :url, allow_destroy: true

  has_one :folder, dependent: :destroy

  validates :item_type, presence: true

  def self.get_child_bookmarks(bookmark_id)
    self.where(parent_id: bookmark_id)
  end
end
