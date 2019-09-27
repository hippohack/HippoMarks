class Profile < ApplicationRecord
  belongs_to :account
  has_one_attached :avatar

  validates :name, presence: true
end
