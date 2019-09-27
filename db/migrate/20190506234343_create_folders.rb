class CreateFolders < ActiveRecord::Migration[5.2]
  def change
    create_table :folders do |t|
      t.integer :account_id, null: false
      t.integer :folder_id
      t.integer :parent_count, null: false, default: 0
      t.string :name, null: false

      t.timestamps
    end
  end
end
