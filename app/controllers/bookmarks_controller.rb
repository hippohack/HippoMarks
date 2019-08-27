class BookmarksController < ApplicationController
  before_action :authenticate_account!

  include FolderData

  def index

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

    @bookmark.og_image_url = Bookmark.get_site_capture(@bookmark.url)

    raise if @bookmark.save == false

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

  def update
    @bookmark = current_account.bookmarks.find(params[:id])
    @bookmark.update!(bookmark_params)
    render :show
  end

  def search
    @bookmarks = current_account.bookmarks.search(params[:s])
    # TODO: domain整形
    @domain = 'hoge.com'
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
end
