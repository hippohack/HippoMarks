class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bookmarks, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :profiles, dependent: :destroy
  has_many :settings, dependent: :destroy
  has_many :share_urls, dependent: :destroy
end
