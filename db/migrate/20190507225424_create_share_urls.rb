class CreateShareUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :share_urls do |t|
      t.integer :account_id
      t.text :share_url
      t.integer :folder_id

      t.timestamps
    end
  end
end
