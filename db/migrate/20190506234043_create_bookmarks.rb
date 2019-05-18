class CreateBookmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarks do |t|
      t.integer :account_id
      t.string :name
      t.text :url
      t.integer :folder_id
      t.integer :bookmarkbar_item_id

      t.timestamps
    end
  end
end
