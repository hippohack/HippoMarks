class ProfilesController < ApplicationController

  before_action :set_profile

  def show
    render :edit
  end

  def edit
    
  end

  def update
    if @profile.update!(profile_params)
      if params[:edit_avatar_image]
        render :replace_img
      else
        flash[:notice] = 'Profile updated.'
        render :edit
      end
    end
  end

  def replace_img
    
  end

  private

  def set_profile
    @profile = current_account.profile
  end

  def profile_params
    params.fetch(:profile, {}).permit(
      :account_id,
      :name,
      :twitter_account,
      :avatar,
      :lock_version
    )
  end

end
