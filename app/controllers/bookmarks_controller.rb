class BookmarksController < ApplicationController
  before_action :authenticate_account!, :set_locale
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
    if params[:bookmark].present?
      @bookmark.name = params[:bookmark][:name]
      @bookmark.url = params[:bookmark][:url]
      @bookmark.folder_id = params[:bookmark][:folder_id]
      @bookmark.keyword = params[:bookmark][:keyword]
    end

    # FIXME: 強制的にエラー追加
    if params[:messages] && params[:messages][:url]
      @bookmark.errors.messages[:url] = params[:messages][:url]
    end

    set_folder_data
  end

  def create
    @bookmark = current_account.bookmarks.new(bookmark_params)
    unless @bookmark.folder_id
      @bookmark.folder_id = current_account.bookmarkbar_folder_id
    end

    if @bookmark.save
      CaptureJob.perform_later(@bookmark.id)

      if params[:popup]
        render :show
      else
        redirect_to root_path
      end
    else
      # raise
      flash[:error] = "保存に失敗しました"
      # MEMO: renderではset_folder_dataが呼ばれないのでvueで値不足になる
      # render :add
      # MEMO: redirect_toでは@bookmark.errorsが残らない
      after_update_redirect('add')
    end
  end

  def show

  end

  def edit
    @bookmark = current_account.bookmarks.find(params[:id])
    @belong_folder_ids = belong_folder_ids(@bookmark.id)

    set_folder_data
  end

  def popup_edit
    @bookmark = current_account.bookmarks.find(params[:id])
    @belong_folder_ids = belong_folder_ids(@bookmark.id)

    if params[:bookmark].present?
      @bookmark.name = params[:bookmark][:name]
      @bookmark.url = params[:bookmark][:url]
      @bookmark.folder_id = params[:bookmark][:folder_id]
      @bookmark.keyword = params[:bookmark][:keyword]
    end

    # FIXME: 強制的にエラー追加
    if params[:messages] && params[:messages][:url]
      @bookmark.errors.messages[:url] = params[:messages][:url]
    end

    set_folder_data
  end

  def update
    @bookmark = current_account.bookmarks.find(params[:id])

    # 画像の更新のみ
    if params[:site_image_edit]
      img = Bookmark.img_to_base64(params[:bookmark][:og_image_url].tempfile)
      @bookmark.og_image_url = img
      if @bookmark.save!
        render :replace_img
        return
      end
    end

    # iconのbase64変換
    if params[:bookmark][:icon]
      icon_img = Bookmark.img_to_base64(params[:bookmark][:icon].tempfile)
      @bookmark.icon = icon_img
    end

    if @bookmark.update(bookmark_params)
      if params[:popup]
        render :show
      else
        redirect_to search_bookmarks_path + "?utf8=✓&s=#{session[:search_query]}"
      end
    else
      after_update_redirect('popup_edit')
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy

    redirect_to request.referer
  end

  def search
    @bookmarks = current_account.bookmarks.search(params[:s])
    respond_to do |format|
      format.json
    end
  end

  def replace_img
    @bookmark = current_account.bookmarks.find(params[:id])
  end

  def take_capture
    @bookmark = current_account.bookmarks.find(params[:id])
    @bookmark.og_image_url = Bookmark.get_site_capture(@bookmark.url)

    render :replace_img if @bookmark.save!
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
    @folders = FolderData.folder_tree(current_account)
    @main_folder_id = current_account.bookmarkbar_folder_id
    # raise
  end

  def save_search_query
    return if params[:s].blank?

    session[:search_query] = params[:s]
  end

  def after_update_redirect(action)
    redirect_to controller: 'bookmarks', action: action,
                  'bookmark[name]': params[:bookmark][:name],
                  'bookmark[url]': params[:bookmark][:url],
                  'bookmark[folder_id]': params[:bookmark][:folder_id],
                  'bookmark[keyword]': params[:bookmark][:keyword],
                  messages: @bookmark.errors.messages
  end

  def belong_folder_ids(bookmark_id)
    bookmark = Bookmark.find(bookmark_id)
    belong_folder = Folder.find(bookmark.folder_id)

    parent_folders(belong_folder.id).reverse
  end

  def parent_folders(folder_id, result = [])
    return result unless folder_id.present?

    parent = Folder.find(folder_id)
    result.push parent.id
    # raise
    parent_folders(parent.folder_id, result)
  end
end
