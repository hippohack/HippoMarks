class ApplicationController < ActionController::Base

  # # CSRF - Rails5.2系ではCSRF対策、「protect_from_forgery with: :exception」はどこで設定されているのか｜teratail
  # # https://teratail.com/questions/177576
  # protect_from_forgery prepend: true

  before_action :set_loaded_action, :set_js_debug, :set_locale

  def set_loaded_action
    @loaded_action = controller_path + '#' + action_name
  end

  def set_js_debug
    @js_debug = ENV.fetch('JS_DEBUG_MODE') { false }
  end

  def set_locale
    locale_setting = current_account.settings.find_by(key: 'lang').value
    # TODO: 仮状態
    I18n.locale = 'ja'
    # I18n.locale = locale_setting == 'japanese' ? 'ja' : 'en'
    # raise
  end

end
