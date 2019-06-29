class BookmarksController < ApplicationController
  before_action :authenticate_account!

  def index

  end

  def new
    @bookmark = Bookmark.new
    @bookmark.build_url
  end

  def create
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.account_id = current_account.id
    @bookmark.item_type = 'url'
    @bookmark.url.account_id = current_account.id

    logger.debug 'DEBUG >>>'
    logger.debug @bookmark.inspect
    logger.debug '<<< DEBUG'

    raise if @bookmark.save == false

    render :show
  end

  def show

  end

  def add
    @bookmark = Bookmark.new
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
    # raise
  end

  private
    def bookmark_params
      params.fetch(:bookmark, {}).permit(
        :account_id,
        :item_type,
        url_attributes: [
          :name,
          :url
        ]
      )
    end
end
