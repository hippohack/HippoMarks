class Bookmark < ApplicationRecord
  belongs_to :account
  belongs_to :folder, optional: true

  validates :name, presence: true
  validates :url, presence: true
end
