class HistoriesController < ApplicationController
  def index
    @histories = current_account.bookmarks.histories
  end

  def delete
    @history = current_account.bookmarks.find(params[:id])
    @history.update(last_access_time: nil, impressions: 0)
    redirect_to histories_path
  end

  def delete_all
    if params[:histories]
      @histories = current_account.bookmarks.where(id: params[:histories])
      @histories.update_all(last_access_time: nil, impressions: 0)
      redirect_to histories_path
      return
    end

    @histories = current_account.bookmarks.histories
    @histories.update_all(last_access_time: nil, impressions: 0)
    redirect_to histories_path
  end
end
