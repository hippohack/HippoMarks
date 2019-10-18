class HomeController < ApplicationController
  before_action :authenticate_account!, except: [:welcome]

  def index
    @top_folder = current_account.folders.top_folder(current_account.bookmarkbar_folder_id)
    @sort_setting = current_account.settings.find_by(key: 'item_sort').value

    # TODO: setting/item_sortの値で並び替え
    unless @sort_setting == 'optional'
      @folders = @top_folder.folders.order(@sort_setting.to_sym)
      @bookmarks = @top_folder.bookmarks.order(@sort_setting.to_sym)
    else
      # raise
    end

    # raise
  end

  def welcome
    redirect_to root_path if account_signed_in?
  end
end
