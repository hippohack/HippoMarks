class BookmarksController < ApplicationController
  before_action :authenticate_account!

  def index

  end

  def add
    @bookmark = Bookmark.new
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
