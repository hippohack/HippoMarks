class Api::FoldersController < ApplicationController

  include FolderData

  def show
    folder = current_account.folders.find(params[:id])
    sort_setting = current_account.settings.find_by(key: 'item_sort').value

    folders = folder.folders
    bookmarks = folder.bookmarks

    @folder_items = folder_item_mix(folders, bookmarks, sort_setting)
  end

  def create
    @folder = current_account.folders.new(folder_params)
    @folder.account_id = current_account.id
    # TODO: 最後じゃなくて最初にする？
    @folder.sort_num = last_sort_num(@folder.folder_id) + 1

    raise if @folder.save == false
  end

  def update
    @folder = current_account.folders.find(params[:id])
    @folder.update!(folder_params)
  end

  def destroy
    @folder = current_account.folders.find(params[:id])

    @folder.children.each do |child|
      current_account.folders.find(child.id).destroy
    end

    @folder.destroy
  end

  def many_visits
    # TODO: takeの数任意設定でもいいかも
    @folder_items = current_account.bookmarks.order(impressions: :desc).take(10)
    render :show
  end

  def history
    # TODO: takeの数任意設定でもいいかも
    @folder_items = current_account.bookmarks.order(last_access_time: :desc).take(10)
    render :show
  end

  def move_folder
    raise unless params[:folder_id]

    folder = current_account.folders.find(params[:id])
    folder.folder_id = params[:folder_id]
    # folder.sort_num = params[:sort_num]
    folder.save!

    adjust_sort_num(folder.id, folder.folder_id, folder.sort_num, params[:sort_num])
  end

  def update_sort_num
    target = nil

    target = current_account.folders.find(params[:id]) if params[:type] == 'folders'
    target = current_account.bookmarks.find(params[:id]) if params[:type] == 'bookmarks'

    adjust_sort_num(target, params[:sort_num])
  end

  private

  def folder_params
    params.fetch(:folder, {}).permit(
      :account_id,
      :folder_id,
      :name,
      :sort_num
    )
  end

  def last_sort_num(folder_id)
    folder = current_account.folders.find(folder_id)
    folder_last = folder.folders.order(:sort_num).last
    bookmark_last = folder.bookmarks.order(:sort_num).last

    if bookmark_last.present? && folder_last.present?
      last = folder_last.sort_num < bookmark_last.sort_num ? bookmark_last : folder_last
    end

    last = bookmark_last if bookmark_last.present? && folder_last.blank?
    last = folder_last if bookmark_last.blank? && folder_last.present?

    last ? last.sort_num : -1
  end

  def adjust_sort_num(target_obj, new_sort_num)
    old_sort_num = target_obj.sort_num
    parent_folder = current_account.folders.find_by(id: target_obj.folder_id)
    folder_items = folder_item_mix(parent_folder.folders, parent_folder.bookmarks, 'optional')

    # 下に移動したときindexが一個多いので引く
    new_sort_num -= 1 if new_sort_num > old_sort_num
    direction = new_sort_num > old_sort_num ? 'down' : 'up'

    return if old_sort_num == new_sort_num

    # ソート番号の再設定
    folder_items.each do |item|
      # 自身のフォルダのとき
      if target_obj.id == item.id && target_obj.model_name.name == item.model_name.name
        item.sort_num = new_sort_num
        item.save!
        next
      end

      if direction == 'down' && item.sort_num <= new_sort_num && old_sort_num < item.sort_num
        item.sort_num -= 1
        item.save!
        next
      end

      if direction == 'up' && item.sort_num >= new_sort_num && old_sort_num > item.sort_num
        item.sort_num += 1
        item.save!
        next
      end

      raise if item.sort_num < 0
    end
  end

end
