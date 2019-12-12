class HomeController < ApplicationController
  # before_action :authenticate_account!, except: [:welcome, :release_notes]

  include FolderData

  def index
    unless account_signed_in?
      redirect_to welcome_path
      return
    end

    @top_folder = current_account
                  .folders
                  .top_folder(current_account.bookmarkbar_folder_id)
    @sort_setting = current_account.settings.find_by(key: 'item_sort').value

    folders = @top_folder.folders
    bookmarks = @top_folder.bookmarks
    @top_folder_children = folder_item_mix(folders, bookmarks, @sort_setting)
  end

  def welcome
    redirect_to root_path if account_signed_in?
  end

  def release_notes

  end

end
