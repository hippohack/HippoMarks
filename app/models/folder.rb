class Folder < ApplicationRecord
  belongs_to :account
  belongs_to :bookmarkbar_item

  validates :name, presence: true
end
