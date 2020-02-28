class Api::BookmarksController < ApplicationController
  def index
    # bookmarkbar_items = BookmarkbarItem.bar_items(current_account.id)
    @bookmarkbar_items = BookmarkbarItem.get_bookmarkbar_item(current_account.id)
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
    children = Bookmark.get_child_bookmarks(params[:bookmark_id])
    @folder_items = []

    children.each do |i|
      bookmark = Bookmark.find(i.id)
      if bookmark.item_type == 'url'
        @folder_items.push({ type: 'url', values: bookmark.url })
      else
        @folder_items.push({ type: 'folder', values: bookmark.folder })
      end
    end
    # raise
    @folder_items
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
  end

  # MEMO: history用のtouch処理をここに追加した
  # MEMO: キャプチャ類の自動取得処理をここに追加した
  def increment_impression
    return nil if params[:increment] != true

    @bookmark = current_account.bookmarks.find(params[:bookmark_id])
    @bookmark.impressions += 1
    @bookmark.save!

    # FIXME: 2回クエリーが飛ぶので微妙
    @bookmark.touch(:last_access_time)

    # 【サポーター限定】もしファビコンとキャプチャがなければ取ってくるJobを追加する
    if @supporter_account
      @bookmark.add_fetch_favicon_and_capture_job
    end
  end
end
