class BookmarkbarItem < ApplicationRecord
  belongs_to :account

  default_scope { order(order_num: :asc) }
  scope :bar_items, ->(account_id) { where(account_id: account_id) }

  def self.get_bookmarkbar_item(account_id)
    return bar_items(account_id).map do |i|
      Object.const_get(i.item_type.classify).find(i.item_id)
    end
  end
end
