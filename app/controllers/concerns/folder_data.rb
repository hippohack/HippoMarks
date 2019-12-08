module FolderData
  extend ActiveSupport::Concern

  def self.folders(current_account)
    folders = current_account.folders.order("parent_count DESC")
    # 階層構造に整形
    tmp_folders = {}

    folders.each do |folder|
      tmp_folders[folder.parent_count] = {}
    end

    folders.each do |folder|
      if tmp_folders[folder.parent_count][folder.folder_id].is_a?(Array)
        tmp_folders[folder.parent_count][folder.folder_id].push(folder)
      else
        tmp_folders[folder.parent_count][folder.folder_id ? folder.folder_id : "top_folder"] = [folder]
      end
    end

    # TODO: リファクタリング
    tmp_top_folder_id = tmp_folders[0]['top_folder'][0].id
    
    # # topはいらないので消す
    # tmp_folders.delete(0)
    # raise
    
    return {
      folders: tmp_folders,
      all_folders: folders,
      top_folder_id: tmp_top_folder_id
    }
  end

  def self.test
    'hoge'
  end

  def folder_item_mix(folders, bookmarks, sort_type)
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