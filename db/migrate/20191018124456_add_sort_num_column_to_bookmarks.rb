class AddSortNumColumnToBookmarks < ActiveRecord::Migration[5.2]
  def change
    add_column :bookmarks, :sort_num, :integer, default: 0, after: :last_access_time
  end
end
