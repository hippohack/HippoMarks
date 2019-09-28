class CreateBookmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarks do |t|
      t.integer :account_id, null: false
      t.integer :folder_id
      t.string :name
      t.text :url, null: false
      t.text :icon
      t.text :keyword
      t.text :og_image_url

      t.timestamps
    end
  end
end
