class Bookmark < ApplicationRecord
  belongs_to :account
  has_many :urls, dependent: :destroy
  has_many :folders, dependent: :destroy

  validates :item_type, presence: true
end
