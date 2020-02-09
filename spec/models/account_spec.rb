require 'rails_helper'

RSpec.describe Account, type: :model do
  # 姓、名、メール、パスワードがあれば有効な状態であること
  it 'is valid with a email, and password' do
    account = Account.new(
      email: 'benzoh.g@gmail.com',
      password: 'source-no-nidoduke-kinshi',
      bookmarkbar_folder_id: 100
    )
    expect(account).to be_valid
  end

  # 名がなければ無効な状態であること
  it 'is invalid without a first name' do
    account = Account.new(email: nil)
    account.valid?
    expect(account.errors[:email]).to include("can't be blank")
  end

  # 姓がなければ無効な状態であること
  it 'is invalid without a last name' do
    account = Account.new(password: nil)
    account.valid?
    expect(account.errors[:password]).to include("can't be blank")
  end

  # 重複したメールアドレスなら無効な状態であること
  it 'is invalid with a duplicate email address' do
    account = Account.new(
      email: 'benzoh.g@gmail.com',
      password: 'wordpress',
      bookmarkbar_folder_id: 101
    )
    account.skip_confirmation!
    account.save

    account = Account.new(
      email: 'benzoh.g@gmail.com',
      password: 'wordpress',
      bookmarkbar_folder_id: 102
    )

    account.valid?
    expect(account.errors[:email]).to include('has already been taken')
  end

  # ユーザーのフルネームを文字列として返すこと
  it "returns a user's full name as a string"
end
