class CreateBookmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarks do |t|
      t.integer :account_id, null: false
      t.integer :folder_id
      t.string :name, null: false
      t.string :url, null: false

      t.timestamps
    end
  end
end
