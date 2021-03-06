class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable

  has_many :folders, dependent: :destroy
  accepts_nested_attributes_for :folders, allow_destroy: true
  has_many :bookmarks, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :settings, dependent: :destroy
  has_many :share_urls, dependent: :destroy

  validates :email, uniqueness: true

  after_create :account_initialize

  def self.create_demo_account
    account = Account.new(
      email: "#{SecureRandom.base64(4)}@hippohack.me",
      password: ENV.fetch('DEMO_ACCOUNT_PASS') {  'demonedemodemo' }
    )
    # raise
    account.skip_confirmation!
    account.save

    account
  end

  def self.find_for_oauth(auth)
    account = Account.where(uid: auth.uid, provider: auth.provider).first

    unless account
      account = Account.new(
        uid:      auth.uid,
        provider: auth.provider,
        email:    Account.dummy_email(auth),
        password: Devise.friendly_token[0, 20]
      )
  
      account.build_profile(
        name: auth.info.name,
        twitter_account: auth.provider == 'twitter' ? '@' + auth.info.nickname : nil,
        avatar: nil
        # バリデーションにひっかかる
        # 別途アップロード処理がいるのか
        # avatar: auth.info.image
      )
      
      account.skip_confirmation!
      account.save
    end

    account
  end

  def self.find_for_oauth_with_patreon(uid, provider, name, email)
    account = Account.where(uid: uid, provider: provider).first

    unless account
      account = Account.new(
        uid:      uid,
        provider: provider,
        email:    "#{uid}-#{provider}@example.com",
        # email:    email,
        password: Devise.friendly_token[0, 20]
      )
  
      account.build_profile(
        name: name,
        twitter_account: nil,
        avatar: nil
      )
      
      account.skip_confirmation!
      account.save
    end

    account
  end

  private

  def self.upload_avatar(image_url)
    # TODO: OAuth でのログイン時にアバターをアップロードする
  end

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end

  def account_initialize
    # oauthで設定されている場合スキップする
    if self.profile.blank?
      self.build_profile(
        name: self.email,
        twitter_account: nil,
        avatar: nil
      )
    end

    self.folders.build(
      name: 'MAIN_FOLDER',
      folder_id: nil,
    )
    self.save!
    self.bookmarkbar_folder_id = self.folders[0].id
    self.folders[0][:account_id] = self.id
    self.save!

    # make default setting
    self.folders.build(
      name: 'Favorite',
      folder_id: self.bookmarkbar_folder_id,
    )
    self.save!

    self.bookmarks.build(
      name: 'HippoMarks',
      url: ENV.fetch('HOMEURL'),
      folder_id: self.folders[1].id,
      icon: ActionController::Base.helpers.asset_path('favicon.png'),
      keyword: 'bookmarks, main, start',
      og_image_url: ActionController::Base.helpers.asset_path('og.png')
    )

    # TODO: 項目追加ごとに修正が必要
    self.settings.build(
      [
        [key: 'lang', value: 'english'],
        [key: 'home_url', value: '/'],
        [key: 'show_many_visits', value: 'true'],
        [key: 'many_visits_num', value: '10'],
        [key: 'show_history', value: 'true'],
        [key: 'history_num', value: '10'],
        [key: 'item_sort', value: 'optional'],
        [key: 'show_bookmarklet', value: 'true']
      ]
    )
    self.save!
  end
end
