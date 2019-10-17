class CreateSortMasters < ActiveRecord::Migration[5.2]
  def change
    create_table :sort_masters do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
  end
end
