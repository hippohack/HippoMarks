class BookmarkbarItem < ApplicationRecord
  belongs_to :account
  has_many :bookmarks
  has_many :folders
end
