class Url < ApplicationRecord
  belongs_to :account
  belongs_to :bookmark

  validates :name, presence: true
  validates :url, presence: true
end
