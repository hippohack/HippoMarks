class CreateBookmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarks do |t|
      t.integer :account_id, null: false
      t.integer :parent_id
      t.string :type, default: 'url', null: false

      t.timestamps
    end
  end
end
