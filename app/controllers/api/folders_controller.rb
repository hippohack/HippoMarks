class Api::FoldersController < ApplicationController

  def show
    folder = current_account.folders.find(params[:id])
    @folders = folder.folders
    @bookmarks = folder.bookmarks
  end

end
