class AddSortNumColumnToFolders < ActiveRecord::Migration[5.2]
  def change
    add_column :folders, :sort_num, :integer, default: 0, after: :name
  end
end
