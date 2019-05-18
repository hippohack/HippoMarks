class Folder < ApplicationRecord
  belongs_to :account
  has_many :bookmarks, dependent: :destroy

  validates :name, presence: true
end
