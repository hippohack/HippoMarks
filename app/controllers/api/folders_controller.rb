class Api::FoldersController < ApplicationController

  def index
    @folders = current_account.folders.group_by { |folder|
      folder.bookmark.parent_id
    }
  end

end
