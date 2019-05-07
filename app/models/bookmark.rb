class Bookmark < ApplicationRecord
  belongs_to :account

  validates :name, presence: true
  validates :url, presence: true
end
