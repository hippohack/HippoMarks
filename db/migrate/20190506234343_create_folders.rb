class CreateFolders < ActiveRecord::Migration[5.2]
  def change
    create_table :folders do |t|
      t.integer :account_id, null: false
      t.string :name, null: false
      t.integer :bookmark_id, null: false

      t.timestamps
    end
  end
end
