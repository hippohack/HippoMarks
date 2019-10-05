class AddImpressionColumnToBookmarks < ActiveRecord::Migration[5.2]
  def change
    add_column :bookmarks, :impressions, :integer, default: 0, after: :og_image_url
  end
end
