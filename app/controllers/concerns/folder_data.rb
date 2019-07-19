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
    # topはいらないので消す
    tmp_folders.delete(0)
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
end