module FolderData
  extend ActiveSupport::Concern

  def self.folder_tree(current_account)
    [folder(current_account.bookmarkbar_folder_id)]
  end

  def self.folder(folder_id)
    folder = Folder.find_by(id: folder_id)
    children = children(folder.id)

    { folder: folder, children: children }
  end

  def self.children(folder_id)
    children = Folder.where(folder_id: folder_id)

    mapped = children.map do |child|
      folder(child.id)
    end
    mapped
  end

  # フォルダとブックマークをミックスしてソート
  def folder_item_mix(folders, bookmarks, sort_type = 'name')
    res = []
    folders.each do |folder|
      res.push(folder)
    end

    bookmarks.each do |bookmark|
      res.push(bookmark)
    end

    case sort_type
    when 'optional'
      sort_by_sort_num(res)
    when 'name'
      sort_by_name(res)
    when 'created_at'
      sort_by_created_at(res)
    when 'updated_at'
      sort_by_updated_at(res)
    else
      raise
    end
  end

  # ここに置くかどうかは別途判断が必要
  def sort_by_sort_num(items)
    items.sort_by! do |item|
      item[:sort_num]
    end
  end

  def sort_by_name(items)
    items.sort_by! do |item|
      item[:name]
    end
  end

  def sort_by_created_at(items)
    items.sort_by! do |item|
      item[:created_at]
    end
  end

  def sort_by_updated_at(items)
    items.sort_by! do |item|
      item[:updated_by]
    end
  end
end