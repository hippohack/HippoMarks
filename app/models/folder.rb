class Folder < ApplicationRecord
  belongs_to :account, primary_key: 'bookmarkbar_folder_id'
  has_many :bookmarks, dependent: :destroy
  accepts_nested_attributes_for :bookmarks, allow_destroy: true

  validates :name, presence: true

  # default_scope { order(order_num: :asc) }
  scope :top_folder, ->(account) { find(account.bookmarkbar_folder_id) }

  # TODO: self joinにすべき？
  # Active Record Associations — Ruby on Rails Guides
  # https://guides.rubyonrails.org/association_basics.html#self-joins
  def folders
    Folder.where(folder_id: id)
  end
end
