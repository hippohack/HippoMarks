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
end
