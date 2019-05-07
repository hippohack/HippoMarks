class CreateFolders < ActiveRecord::Migration[5.2]
  def change
    create_table :folders do |t|
      t.integer :account_id
      t.string :name
      t.integer :level
      t.integer :parent_folder_id

      t.timestamps
    end
  end
end