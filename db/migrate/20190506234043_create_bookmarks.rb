class CreateBookmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarks do |t|
      t.integer :account_id, null: false
      t.integer :folder_id
      t.string :name
      t.text :url, null: false, limit: 4294967295
      t.text :icon, limit: 4294967295
      t.text :keyword, limit: 4294967295
      t.text :og_image_url, limit: 4294967295

      t.timestamps
    end
  end
end
