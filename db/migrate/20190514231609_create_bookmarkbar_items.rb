class CreateBookmarkbarItems < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarkbar_items do |t|


      t.timestamps
    end
  end
end
