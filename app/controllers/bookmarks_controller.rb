class BookmarksController < ApplicationController
  before_action :authenticate_account!

  include FolderData

  def index

  end

  def new
    @bookmark = current_account.bookmarks.new
    @bookmark.url = params[:bkmk]
    @bookmark.name = params[:title]

    folder_data = FolderData.folders(current_account)
    @folders = folder_data[:folders]
    @all_folders = folder_data[:all_folders]
    @top_folder_id = folder_data[:top_folder_id]
  end

  def add
    @bookmark = current_account.bookmarks.new
    folder_data = FolderData.folders(current_account)
    @folders = folder_data[:folders]
    @all_folders = folder_data[:all_folders]
    @top_folder_id = folder_data[:top_folder_id]
    # raise
  end

  def create
    @bookmark = current_account.bookmarks.new(bookmark_params)
    raise if @bookmark.save == false

    if params[:popup]
      render :show
    else
      redirect_to root_path
    end
  end

  def show

  end

  private
    def bookmark_params
      params.fetch(:bookmark, {}).permit(
        :account_id,
        :folder_id,
        :name,
        :url,
      )
    end
end
