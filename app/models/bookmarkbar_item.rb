class BookmarkbarItem < ApplicationRecord
  belongs_to :account
  has_one :bookmark

  default_scope { order(order_num: :asc) }
  scope :bar_items, ->(account_id) { where(account_id: account_id) }

  def self.get_bookmarkbar_item(account_id)
    items = []

    bar_items(account_id).each do |i|
      bookmark = Bookmark.find(i.bookmark_id)
      if bookmark.item_type == 'url'
        items.push({ type: 'url', values: bookmark.url })
      else
        items.push({ type: 'folder', values: bookmark.folder })
      end
    end

    return items
  end
end
