class HomeController < ApplicationController
  before_action :authenticate_account!, except: [:welcome]

  def index
    @top_folder = current_account.folders.top_folder(current_account.bookmarkbar_folder_id)
    @folders = @top_folder.folders
    @bookmarks = @top_folder.bookmarks
    @sort_setting = current_account.settings.find_by(key: 'item_sort').value
    # raise
  end

  def welcome
    redirect_to root_path if account_signed_in?
  end
end
