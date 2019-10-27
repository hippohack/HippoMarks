class Api::FoldersController < ApplicationController

  include FolderData

  def show
    folder = current_account.folders.find(params[:id])
    @folders = folder.folders.order(created_at: :desc)
    @bookmarks = folder.bookmarks.order(created_at: :desc)
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

    # 対象以前のものをデクリメント
    edit_targets = parent_folder.folders.where('sort_num <= ?', params[:sort_num])
    edit_targets.update_all('sort_num = sort_num - 1')

    folder.sort_num = params[:sort_num]
    folder.save
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
