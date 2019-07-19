class Api::FoldersController < ApplicationController

  include FolderData

  def show
    folder = current_account.folders.find(params[:id])
    @folders = folder.folders
    @bookmarks = folder.bookmarks
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
