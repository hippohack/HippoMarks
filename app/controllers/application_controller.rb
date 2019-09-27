class ApplicationController < ActionController::Base

  # # CSRF - Rails5.2系ではCSRF対策、「protect_from_forgery with: :exception」はどこで設定されているのか｜teratail
  # # https://teratail.com/questions/177576
  # protect_from_forgery prepend: true

  before_action :set_loaded_action

  def set_loaded_action
    @loaded_action = controller_path + '#' + action_name
  end

end
