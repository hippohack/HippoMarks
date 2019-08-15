class ImportController < ApplicationController
  before_action :authenticate_account!

  def index
    if request.method == 'POST'
      if Bookmark.import(params[:import_file], current_account)
        redirect_to root_path
      end
    end
  end

end
