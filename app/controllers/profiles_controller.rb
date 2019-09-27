class ProfilesController < ApplicationController

  before_action :set_profile

  def show
    render :edit
  end

  def edit
    
  end

  def update
    render :edit if @profile.update!(profile_params)
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
