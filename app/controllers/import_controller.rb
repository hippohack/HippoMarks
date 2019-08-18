class ImportController < ApplicationController
  before_action :authenticate_account!

  def index
    if request.method == 'POST'
      if Bookmark.import(params[:import_file], current_account)
        flash[:notice] = "インポート処理を完了しました"
        redirect_to root_path
      end
    end
  end
end
