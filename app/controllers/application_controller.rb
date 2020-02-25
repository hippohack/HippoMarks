class ApplicationController < ActionController::Base

  # # CSRF - Rails5.2系ではCSRF対策、「protect_from_forgery with: :exception」はどこで設定されているのか｜teratail
  # # https://teratail.com/questions/177576
  # protect_from_forgery prepend: true

  before_action :set_loaded_action, :set_js_debug, :supporter_account?

  def set_loaded_action
    @loaded_action = controller_path + '#' + action_name
  end

  def set_js_debug
    @js_debug = ENV.fetch('JS_DEBUG_MODE') { false }
  end

  def set_locale
    if account_signed_in?
      locale_setting = current_account.settings.find_by(key: 'lang').value
    end

    # FIXME: 他言語が増えたときは修正が必要
    I18n.locale = locale_setting == 'Japanese' ? 'ja' : 'en'
  end

  def supporter_account?
    if account_signed_in?
      api_client = Patreon::API.new(ENV.fetch('PATREON_CREATORS_ACCESS_TOKEN'))
      response = api_client.fetch_campaign_and_patrons()

      unless response.data
        @supporter_account = false
        return
      end
      
      response_data = response.data[0]
      pledges = response_data.pledges
      # @response.pledges[0].patronにサポーター情報あり

      pledges.each do |pledge|
        # FIXME: あってる？ゆるい？
        if (pledge.patron.id == current_account.uid && 'patreon' == current_account.provider) || pledge.patron.email == current_account.email
          @supporter_account = true
          return
        end
      end
      
      @supporter_account = false
    end
  end

end
