class Folder < ApplicationRecord
  belongs_to :account
  belongs_to :bookmark

  validates :name, presence: true
end
