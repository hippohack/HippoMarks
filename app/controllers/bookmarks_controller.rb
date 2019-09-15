class BookmarksController < ApplicationController
  before_action :authenticate_account!
  before_action :save_search_query

  include FolderData

  def index
    redirect_to root_path
  end

  def new
    @bookmark = current_account.bookmarks.new
    @bookmark.url = params[:bkmk]
    @bookmark.name = params[:title]

    set_folder_data
  end

  def add
    @bookmark = current_account.bookmarks.new

    set_folder_data
    # raise
  end

  def create
    @bookmark = current_account.bookmarks.new(bookmark_params)
    unless @bookmark.folder_id
      @bookmark.folder_id = current_account.bookmarkbar_folder_id
    end

    raise if @bookmark.save == false

    # get og and favicon images with job.
    CaptureJob.perform_later(@bookmark.id)

    if params[:popup]
      render :show
    else
      redirect_to root_path
    end
  end

  def show

  end

  def edit
    @bookmark = current_account.bookmarks.find(params[:id])

    set_folder_data
  end

  def popup_edit
    @bookmark = current_account.bookmarks.find(params[:id])

    set_folder_data
  end

  def update
    @bookmark = current_account.bookmarks.find(params[:id])
    @bookmark.update!(bookmark_params)

    if params[:popup]
      render :show
    else
      redirect_to search_bookmarks_path + "?utf8=✓&s=#{session[:search_query]}"
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy

    redirect_to request.referer
  end

  def search
    @bookmarks = current_account.bookmarks.search(params[:s])
  end

  private

  def bookmark_params
    params.fetch(:bookmark, {}).permit(
      :account_id,
      :folder_id,
      :name,
      :url,
      :keyword,
      :og_image_url
    )
  end

  def set_folder_data
    folder_data = FolderData.folders(current_account)
    @folders = folder_data[:folders]
    @all_folders = folder_data[:all_folders]
    @top_folder_id = folder_data[:top_folder_id]
  end

  def save_search_query
    return if params[:s].blank?

    session[:search_query] = params[:s]
  end
end
