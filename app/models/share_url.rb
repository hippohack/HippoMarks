class ShareUrl < ApplicationRecord
  belongs_to :account

  validates :share_url, presence: true
  validates :folder_id, presence: true
end
