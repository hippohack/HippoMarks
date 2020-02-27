class HistoriesController < ApplicationController

  before_action :set_locale

  def index
    @histories = current_account.bookmarks.histories.paginate(page: params[:page], per_page: 10)
  end

  def delete
    @history = current_account.bookmarks.find(params[:id])
    @history.update(last_access_time: nil, impressions: 0)
    redirect_to histories_path
  end

  def delete_all
    if params[:histories]
      @histories = current_account.bookmarks.where(id: params[:histories])
      if @histories.update_all(last_access_time: nil, impressions: 0)
        flash[:notice] = 'Histories has been deleted.'
        redirect_to histories_path
        return
      end
      return
    end

    @histories = current_account.bookmarks.histories
    if @histories.update_all(last_access_time: nil, impressions: 0)
      flash[:notice] = 'Histories has been deleted.'
      redirect_to histories_path
    end
  end
end
