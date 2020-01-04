class RemoveColumnToFolder < ActiveRecord::Migration[5.2]
  def change
    remove_column :folders, :parent_count
  end
end
