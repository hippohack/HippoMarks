class AddColumnsToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :uid, :string
    add_column :accounts, :provider, :string
  end
end
