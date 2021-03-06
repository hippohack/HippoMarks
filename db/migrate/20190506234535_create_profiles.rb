class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.integer :account_id
      t.string :name
      t.string :twitter_account
      t.string :avatar
      t.integer :lock_version, default: 0

      t.timestamps
    end
  end
end
