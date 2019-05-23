class CreateBookmarkbarItems < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarkbar_items do |t|
      t.integer :account_id, null: false
      t.integer :bookmark_id, null: false
      t.integer :order_num, default: 0

      t.timestamps
    end
  end
end
