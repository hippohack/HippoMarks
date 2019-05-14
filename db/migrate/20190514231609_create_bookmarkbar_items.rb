class CreateBookmarkbarItems < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarkbar_items do |t|
      t.integer :account_id
      t.integer :bookmark_id
      t.integer :folder_id
      t.integer :order_num

      t.timestamps
    end
  end
end
