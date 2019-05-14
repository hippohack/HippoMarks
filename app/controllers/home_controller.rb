class HomeController < ApplicationController
  before_action :authenticate_account!

  def index
    # @bookmarks = Bookmark.find_by(account_id: current_account.id)
    # raise
  end
end
