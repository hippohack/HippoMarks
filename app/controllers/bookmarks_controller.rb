class BookmarksController < ApplicationController
  before_action :authenticate_account!

  def index

  end

  def new
    @bookmark = Bookmark.new
  end

  def create
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.account_id = current_account.id

    raise if @bookmark.save == false

    render :show
  end

  def show

  end

  private
    def bookmark_params
      params.fetch(:bookmark, {}).permit(
        :name,
        :url,
        :folder_id
      )
    end
end
