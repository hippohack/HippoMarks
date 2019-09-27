class Folder < ApplicationRecord
  belongs_to :account, primary_key: 'bookmarkbar_folder_id'
  has_many :bookmarks, dependent: :destroy
  accepts_nested_attributes_for :bookmarks, allow_destroy: true

  validates :name, presence: true

  # default_scope { order(order_num: :asc) }
  scope :top_folder, ->(bookmarkbar_folder_id) { find(bookmarkbar_folder_id) }

  # TODO: self joinにすべき？
  # Active Record Associations — Ruby on Rails Guides
  # https://guides.rubyonrails.org/association_basics.html#self-joins
  def folders
    Folder.where(folder_id: id)
  end

  # フォルダに属するフォルダをすべて取得
  # return ネストなしの配列
  def children
    folders = []
    ids = []

    folders += self.folders
    ids += folders.pluck(:id)

    ids.each do |id|
      add = Folder.where(folder_id: id)
      folders += add

      ids += add.pluck(:id)
      ids.delete(id)

      break unless ids
    end

    folders
  end

end
