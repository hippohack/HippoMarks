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
      @tokens = PatreonToken.tokens

      access_token = @tokens['access_token']
      register = @tokens['register_date']

      # MEMO: 本当に30日で切れる？もっと早いような。。
      if register.nil? || (Date.parse(Date.today.strftime("%Y/%m/%d")) - Date.parse(register.strftime("%Y/%m/%d"))).to_i > 30
        refresh_token = @tokens['refresh_token']
        oauth_client = Patreon::OAuth.new(ENV.fetch('PATREON_CLIENT_ID'), ENV.fetch('PATREON_CLIENT_SECRET'))
        tokens = oauth_client.refresh_token(refresh_token, accounts_auth_patreon_callback_url)
        
        @tokens['register_date'] = Date.today
        @tokens['access_token'] = tokens['access_token']
        @tokens['refresh_token'] = tokens['refresh_token']
        @tokens.save!

        access_token = tokens['access_token']
      end

      api_client = Patreon::API.new(access_token)
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
