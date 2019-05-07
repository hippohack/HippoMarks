class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.integer :account_id
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
