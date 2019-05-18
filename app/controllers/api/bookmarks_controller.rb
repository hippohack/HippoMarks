class Api::BookmarksController < ApplicationController

  def index
    @bookmarkbar_items = BookmarkbarItem.get_bookmarkbar_item(current_account.id)
    # bookmarks = Bookmark.where(account_id: current_account.id).limit(10)
    # # TODO: フォルダー振り分けしたデータ返す
    # @bookmarks = bookmarks.group_by { |item|
    #   item.folder_id
    # }
  end

end
