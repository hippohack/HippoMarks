class HomeController < ApplicationController
  before_action :authenticate_account!

  def index
    @top_folder = current_account.folders.top_folder(current_account)
    @folders = @top_folder.folders
    @bookmarks = @top_folder.bookmarks
    # raise
  end
end
