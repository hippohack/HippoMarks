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

  def update_sort_num
    folder = current_account.folders.find(params[:id])
    parent_folder = current_account.folders.find(folder.folder_id)

    new_sort_num = params[:sort_num]

    # 下に移動したときindexが一個多いので引く
    new_sort_num -= 1 if new_sort_num > folder.sort_num
    direction = new_sort_num > folder.sort_num ? 'down' : 'up'

    return if folder.sort_num == new_sort_num

    # TODO: 対象の以前以後の再設定
    parent_folder.folders.each do |f|
      old_sort_num = f.sort_num

      if direction == 'down' && folder.id == f.id
        f.sort_num = new_sort_num
        f.save!
        next
      end

      if direction == 'down' && f.sort_num <= new_sort_num
        f.sort_num -= 1
        f.save!
        next
      end

      next
    end
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

end
