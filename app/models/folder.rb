class Folder < ApplicationRecord
  belongs_to :account
  belongs_to :bookmark

  validates :name, presence: true

  # default_scope { order(order_num: :asc) }
  # scope :bar_items, ->(account_id) { where(account_id: account_id) }
end
