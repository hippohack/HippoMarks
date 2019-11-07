class HistoriesController < ApplicationController
  def index
    @histories = current_account.bookmarks.histories
  end

  def delete
  end

  def delete_all
  end
end
