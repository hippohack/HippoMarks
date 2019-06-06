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
  id: 1,
  email: 'admin@example.com',
  password: 'hirakegoma',
  encrypted_password: '$2a$11$W5qWWly1reTS93AxlYYqmeQpBSu9BcMzXDBV4/Kyfk35A6BDYQarq',
  bookmarkbar_folder_id: 0
)
account.folders.build(
  account_id: account.id,
  name: 'user_bookmarkber',
  folder_id: nil,
  parent_count: 0
)
account.save!
account.bookmarkbar_folder_id = account.folders[0].id
account.save!

# b = Bookmark.create( account_id: a.id, item_type: "url" )
# Url.create( account_id: a.id, name: 'benzoh.com', url: 'https://www.benzoh.com', bookmark_id: b.id )
# BookmarkbarItem.create( account_id: a.id, bookmark_id: b.id, order_num: 1 )

# b = Bookmark.create( account_id: a.id, item_type: "url" )
# Url.create( account_id: a.id, name: 'start30blog.com', url: 'https://www.benzoh.com', bookmark_id: b.id )
# BookmarkbarItem.create( account_id: a.id, bookmark_id: b.id, order_num: 2 )

# b = Bookmark.create( account_id: a.id, item_type: "folder" )
# f = Folder.create( account_id: a.id, bookmark_id: b.id, name: "Folder1" )
# BookmarkbarItem.create( account_id: a.id, bookmark_id: b.id, order_num: 3 )
# b = Bookmark.create( account_id: a.id, item_type: "url", parent_id: b.id)
# Url.create( account_id: a.id, name: 'hoge.com', url: 'https://www.benzoh.com', bookmark_id: b.id )

# b = Bookmark.create( account_id: a.id, parent_id: b.id, item_type: "folder" )
# f = Folder.create( account_id: a.id, bookmark_id: b.id, name: "Folder2" )
# BookmarkbarItem.create( account_id: a.id, bookmark_id: b.id, order_num: 4 )
# b = Bookmark.create( account_id: a.id, item_type: "url", parent_id: b.id)
# Url.create( account_id: a.id, name: 'fuga.com', url: 'https://www.benzoh.com', bookmark_id: b.id )

# b = Bookmark.create( account_id: a.id, parent_id: b.id, item_type: "folder" )
# f = Folder.create( account_id: a.id, bookmark_id: b.id, name: "Folder3" )
# BookmarkbarItem.create( account_id: a.id, bookmark_id: b.id, order_num: 5 )
# b = Bookmark.create( account_id: a.id, item_type: "url", parent_id: b.id)
# Url.create( account_id: a.id, name: 'piyo.com', url: 'https://www.benzoh.com', bookmark_id: b.id )

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
