class Api::FoldersController < ApplicationController

  include FolderData

  def show
    folder = current_account.folders.find(params[:id])
    sort_setting = current_account.settings.find_by(key: 'item_sort').value

    unless sort_setting == 'optional'
      @folders = folder.folders.order(sort_setting.to_sym)
      @bookmarks = folder.bookmarks.order(sort_setting.to_sym)
    else
      @folders = folder.folders.order(:sort_num)
      @bookmarks = folder.bookmarks.order(:sort_num)
    end
  end

  def create
    logger.debug 'DEBUG >>>'
    logger.debug params
    logger.debug '<<< DEBUG'
    @folder = current_account.folders.new(folder_params)
    @folder.account_id = current_account.id
    raise if @folder.save == false

    folder_data = FolderData.folders(current_account)
    @folders = folder_data[:folders]
    @all_folders = folder_data[:all_folders]
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
    @folders = []
    # TODO: takeの数任意設定でもいいかも
    @bookmarks = current_account.bookmarks.order(impressions: :desc).take(10)
    render :show
  end

  def history
    @folders = []
    # TODO: takeの数任意設定でもいいかも
    @bookmarks = current_account.bookmarks.order(last_access_time: :desc).take(10)
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
    folder = current_account.folders.find(params[:id])

    adjust_sort_num(folder.id, folder.folder_id, folder.sort_num, params[:sort_num])
  end

  private

  def folder_params
    params.fetch(:folder, {}).permit(
      :account_id,
      :folder_id,
      :name,
      :parent_count,
    )
  end

  def adjust_sort_num(folder_id, parent_folder_id, old_sort_num, new_sort_num)
    parent_folder = current_account.folders.find(parent_folder_id)

    # 下に移動したときindexが一個多いので引く
    new_sort_num -= 1 if new_sort_num > old_sort_num
    direction = new_sort_num > old_sort_num ? 'down' : 'up'

    return if old_sort_num == new_sort_num

    # ソート番号の再設定
    parent_folder.folders.each do |f|
      if folder_id == f.id
        f.sort_num = new_sort_num
        f.save!
        next
      end

      if direction == 'down' && f.sort_num <= new_sort_num && old_sort_num < f.sort_num
        f.sort_num -= 1
        f.save!
        next
      end

      if direction == 'up' && f.sort_num >= new_sort_num && old_sort_num > f.sort_num
        f.sort_num += 1
        f.save!
        next
      end

      raise if f.sort_num < 0
    end
  end

end
