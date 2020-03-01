class CreatePatreonTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :patreon_tokens do |t|
      t.string :access_token
      t.date :register_date
      t.string :refresh_token

      t.timestamps
    end
  end
end
