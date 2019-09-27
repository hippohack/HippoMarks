# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 3.times { Task.create!(name: 'Sample Task') }
# 2.times { Task.create!(name: 'Sample Task', is_done: true) }

Account.all.delete_all
Folder.all.delete_all
Bookmark.all.delete_all
# Url.all.delete_all
# BookmarkbarItem.all.delete_all

account = Account.new(
  email: 'admin@example.com',
  password: 'hirakegoma',
  encrypted_password: '$2a$11$W5qWWly1reTS93AxlYYqmeQpBSu9BcMzXDBV4/Kyfk35A6BDYQarq',
  bookmarkbar_folder_id: 0,
  confirmed_at: Time.now
)
account.build_profile(
  name: account.email,
  twitter_account: nil,
  avatar: nil
)
account.folders.build(
  name: 'user_bookmarkber',
  folder_id: nil,
  parent_count: 0
)
account.save!
print "account saved.\n"

account.bookmarkbar_folder_id = account.folders[0].id
account.folders[0][:account_id] = account.id
account.save!
print "account updated.\n"

folder = account.folders.find(account.bookmarkbar_folder_id)

folder.bookmarks.build(
  account_id: account.id,
  name: 'hoge',
  url: 'https://www.hoge.com'
)
folder.save!
print "bookmark saved.\n"

folder2 = account.folders.build(
  account_id: account.id,
  name: 'fuga',
  folder_id: account.bookmarkbar_folder_id,
  parent_count: 1
)
folder2.bookmarks.build(
  [
    {
      account_id: account.id,
      name: 'one',
      url: 'www.one.com',
    },
    {
      account_id: account.id,
      name: 'two',
      url: 'www.two.com',
    }
  ]
)
folder2.save!
print "folder2 saved.\n"

folder3 = account.folders.build(
  account_id: account.id,
  name: 'maccho',
  folder_id: folder2.id,
  parent_count: 2
)
folder3.bookmarks.build(
  [
    {
      account_id: account.id,
      name: 'three',
      url: 'www.three.com',
    },
    {
      account_id: account.id,
      name: 'four',
      url: 'www.four.com',
    }
  ]
)
folder3.save!
print "folder3 saved.\n"
