class SettingsController < ApplicationController
  before_action :set_setting

  def index
    render :edit
  end

  def edit

  end

  def update
    params.fetch(:setting, {}).each do |param|
      setting = @settings.find_by(key: param[:key])
      setting.update!(setting_attributes(param))
    end
    render :edit
  end

  private

  def set_setting
    @settings = current_account.settings
  end

  def setting_params
    params.fetch(:setting, {}).permit(
      :account_id,
      :key,
      :value,
      :lock_version
    )
  end

  def setting_attributes(params)
    params.permit(
      :account_id,
      :key,
      :value,
      :lock_version
    )
  end
end
