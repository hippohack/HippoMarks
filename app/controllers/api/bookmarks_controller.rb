class Api::BookmarksController < ApplicationController

  def index
    @bookmarkbar_items = BookmarkbarItem.bar_items(current_account.id)
    # @bookmarkbar_items = BookmarkbarItem.get_bookmarkbar_item(current_account.id)
    # bookmarks = Bookmark.where(account_id: current_account.id).limit(10)
    # # TODO: フォルダー振り分けしたデータ返す
    # @bookmarks = bookmarks.group_by { |item|
    #   item.folder_id
    # }
  end

  def show
    @bookmark = Bookmark.find(params[:id])
  end

  def folder
    @folder = Folder.find(params[:folder_id])
  end

  def folder_items
    # @folder_items = ['hoge', 'fuga']
    @folder_items = Folder.find(params[:folder_id]).bookmarks
  end

end
