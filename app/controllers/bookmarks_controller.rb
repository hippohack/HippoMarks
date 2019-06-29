class BookmarksController < ApplicationController
  before_action :authenticate_account!

  def index

  end

  def new
    @bookmark = Bookmark.new
    @bookmark.build_url
  end

  def add
    @bookmark = current_account.bookmarks.new
    folders = current_account.folders.order("parent_count DESC")
    # 階層構造に整形
    @folders = {}

    folders.each do |folder|
      @folders[folder.parent_count] = {}
    end

    folders.each do |folder|
      if @folders[folder.parent_count][folder.folder_id].is_a?(Array)
        @folders[folder.parent_count][folder.folder_id].push(folder)
      else
        @folders[folder.parent_count][folder.folder_id ? folder.folder_id : "top_folder"] = [folder]
      end
    end

    # TODO: リファクタリング
    @top_folder_id = @folders[0]['top_folder'][0].id
    # topはいらないので消す
    @folders.delete(0)
    @all_folders = folders
  end

  def create
    @bookmark = current_account.bookmarks.new(bookmark_params)
    raise if @bookmark.save == false
    redirect_to root_path
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
