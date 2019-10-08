class AddLastAccessTimeColumnToBookmarks < ActiveRecord::Migration[5.2]
  def change
    add_column :bookmarks, :last_access_time, :datetime, after: :impressions
  end
end
