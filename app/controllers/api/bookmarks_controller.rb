class Api::BookmarksController < ApplicationController

  def index
    bookmarks = Bookmark.where(account_id: current_account.id).limit(10)
    # TODO: フォルダー振り分けしたデータ返す
    @bookmarks = bookmarks.group_by { |item|
      item.folder_id
    }
  end

end
