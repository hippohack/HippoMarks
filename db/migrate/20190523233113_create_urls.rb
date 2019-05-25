class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.integer :account_id
      t.integer :bookmark_id
      t.string :name, null: false
      t.string :url, null: false

      t.timestamps
    end
  end
end
