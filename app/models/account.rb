class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  has_many :folders, dependent: :destroy
  accepts_nested_attributes_for :folders, allow_destroy: true
  has_many :bookmarks, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :settings, dependent: :destroy
  has_many :share_urls, dependent: :destroy

  validates :email, uniqueness: true

  after_create :account_initialize

  private

  def account_initialize
    self.build_profile(
      name: self.email,
      twitter_account: nil,
      avatar: nil
    )

    self.folders.build(
      name: 'MAIN_FOLDER',
      folder_id: nil,
      parent_count: 0
    )
    self.save!
    self.bookmarkbar_folder_id = self.folders[0].id
    self.folders[0][:account_id] = self.id
    self.save!

    # make default setting
    self.folders.build(
      name: 'Favorite',
      folder_id: self.bookmarkbar_folder_id,
      parent_count: 1
    )
    self.save!

    self.bookmarks.build(
      name: 'Bookmarks',
      url: ENV.fetch('HOMEURL'),
      folder_id: self.folders[1].id,
      icon: ActionController::Base.helpers.asset_path('favicon.png'),
      keyword: 'bookmarks, main, start',
      og_image_url: ActionController::Base.helpers.asset_path('og.png')
    )
    self.settings.build(
      [
        [key: 'lang', value: 'japanese'],
        [key: 'home_url', value: '/'],
        [key: 'show_many_visits', value: 'true'],
        [key: 'show_history', value: true]
      ]
    )
    self.save!
  end
end
