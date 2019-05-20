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

a = Account.create!(
  id: 1,
  email: 'admin@example.com',
  password: 'hirakegoma',
  encrypted_password: '$2a$11$W5qWWly1reTS93AxlYYqmeQpBSu9BcMzXDBV4/Kyfk35A6BDYQarq'
)

Folder.all.delete_all
Bookmark.all.delete_all
BookmarkbarItem.all.delete_all

Folder.create(
  account_id: a.id,
  name: "Folder1",
  level: nil,
  parent_folder_id: nil
)

Folder.create(
  account_id: a.id,
  name: "Folder2",
  level: nil,
  parent_folder_id: nil
)

Bookmark.create(
  account_id: a.id,
  folder_id: 1,
  name: "Bookmark1",
  url: "https://www.url-1.com",
)

Bookmark.create(
  account_id: a.id,
  folder_id: 2,
  name: "Bookmark2",
  url: "https://www.url-2.com",
)

Bookmark.create(
  account_id: a.id,
  folder_id: nil,
  name: "Bookmark3",
  url: "https://www.url-3.com",
)

BookmarkbarItem.create(
  account_id: a.id,
  item_type: 'folder',
  item_id: 1,
  order_num: 1
)

BookmarkbarItem.create(
  account_id: a.id,
  item_type: 'folder',
  item_id: 2,
  order_num: 2
)

BookmarkbarItem.create(
  account_id: a.id,
  item_type: 'bookmark',
  item_id: 3,
  order_num: 3
)

# 20.times do |i|
#   Folder.create(
#     account_id: 1,
#     name: "name-#{i}",
#     level: [nil, 1, 2, 3].sample,
#     parent_folder_id: [nil, 1, 2, 3].sample
#   )

#   Bookmark.create(
#     account_id: 1,
#     # account_id: 1..10.sample,
#     folder_id: [nil, 1, 2, 3].sample,
#     name: "Bookmark name-#{i}",
#     url: "https://www.url-#{i}.com",
#   )

#   BookmarkbarItem.create(
#     account_id: 1,
#     item_type: ['bookmark', 'folder'].sample,
#     item_id: [1, 2, 3].sample,
#     order_num: [1, 2, 3].sample
#   )
# end
