class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.string :name
      t.integer :account_id
      t.integer :bookmark_id

      t.timestamps
    end
  end
end
