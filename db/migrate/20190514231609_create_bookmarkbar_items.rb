class CreateBookmarkbarItems < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarkbar_items do |t|
      t.integer :account_id
      t.string :item_type
      t.integer :item_id
      t.integer :order_num

      t.timestamps
    end
  end
end
