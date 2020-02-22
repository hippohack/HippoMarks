# frozen_string_literal: true

require 'patreon'

class Accounts::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  def twitter
    callback_from :twitter
  end

  def patreon
    callback_from_patreon
  end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  private

  def callback_from(provider)
    provider = provider.to_s

    @account = Account.find_for_oauth(request.env['omniauth.auth'])

    if @account.persisted?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider.capitalize)
      sign_in_and_redirect @account, event: :authentication
    else
      session["devise.#{provider}_data"] = request.env['omniauth.auth']
      redirect_to new_account_registration_url
    end
  end

  def callback_from_patreon
    provider = 'patreon'
    oauth_client = Patreon::OAuth.new(ENV.fetch('PATREON_CLIENT_ID'), ENV.fetch('PATREON_CLIENT_SECRET'))
    tokens = oauth_client.get_tokens(params[:code], accounts_auth_patreon_callback_url)
    access_token = tokens['access_token']

    api_client = Patreon::API.new(access_token)
    user_response = api_client.fetch_user()
    @user = user_response.data

    @account = Account.find_for_oauth_with_patreon(@user.id, provider, @user.full_name, @user.email)

    if @account.persisted?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider.capitalize)
      sign_in_and_redirect @account, event: :authentication
    else
      flash[:error] = 'certification failed.'
      redirect_to new_account_registration_url
    end
  end
end
