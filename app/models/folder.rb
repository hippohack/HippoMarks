class Folder < ApplicationRecord
  belongs_to :account, primary_key: 'bookmarkbar_folder_id'
  has_many :bookmarks, dependent: :destroy
  accepts_nested_attributes_for :bookmarks, allow_destroy: true

  validates :name, presence: true

  # default_scope { order(order_num: :asc) }
  # scope :bar_items, ->(account_id) { where(account_id: account_id) }
end
