class Folder < ApplicationRecord
  belongs_to :account, primary_key: 'bookmarkbar_folder_id'
  belongs_to :bookmark, optional: true

  validates :name, presence: true

  # default_scope { order(order_num: :asc) }
  # scope :bar_items, ->(account_id) { where(account_id: account_id) }
end
