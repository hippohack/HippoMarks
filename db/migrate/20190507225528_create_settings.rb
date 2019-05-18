class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.integer :account_id
      t.string :key
      t.string :value
      t.integer :lock_version, default: 0

      t.timestamps
    end
  end
end
