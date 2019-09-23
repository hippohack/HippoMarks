# frozen_string_literal: true

class Accounts::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super

    @account.build_profile(
      name: @account.email,
      twitter_account: nil,
      avatar: nil
    )

    @account.folders.build(
      name: 'MAIN_FOLDER',
      folder_id: nil,
      parent_count: 0
    )
    @account.save!
    @account.bookmarkbar_folder_id = @account.folders[0].id
    @account.folders[0][:account_id] = @account.id
    @account.save!

    # make default setting
    @account.folders.build(
      name: 'Favorite',
      folder_id: @account.bookmarkbar_folder_id,
      parent_count: 1
    )
    @account.save!

    @account.bookmarks.build(
      name: 'Bookmarks',
      url: ENV.fetch('HOMEURL'),
      folder_id: @account.folders[1].id,
      icon: ActionController::Base.helpers.asset_path('favicon.png'),
      keyword: 'bookmarks, main, start',
      og_image_url: ActionController::Base.helpers.asset_path('og.png')
    )
    @account.save!
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:bookmarkbar_folder_id])
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

end
