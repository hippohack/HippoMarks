class SettingsController < ApplicationController
  before_action :set_setting

  def index
    save_default_values if @settings.blank?

    # 設定されてないものがあるかチェックしてなければ追加する
    # FIXME: 設定が増えるたびに編集するのか？
    diff = default_setting_keys
    @settings.each do |s|
      diff.delete(s.key) if default_setting_keys.include?(s.key)
    end
    if diff.present?
      updates = []
      diff.each do |d|
        if ['show_many_visits', 'show_history'].include? d
          updates.push [key: d, value: 'true']
        elsif ['item_sort'].include? d
          updates.push [key: d, value: 'optional']
        else
          updates.push [key: d, value: nil]
        end
      end
      current_account.settings.build(updates)
      current_account.save
      @settings = current_account.settings
    end

    render :edit
  end

  def edit

  end

  def update
    params.fetch(:setting, {}).each do |key, param|
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

  def save_default_values
    current_account.settings.build(default_settings)
    current_account.save
  end

  # TODO: 項目が増えるごとに更新が必要
  def default_settings
    [
      [key: 'lang', value: 'japanese'],
      [key: 'home_url', value: '/'],
      [key: 'show_many_visits', value: 'true'],
      [key: 'show_history', value: 'true'],
      [key: 'item_sort', value: 'optional']
    ]
  end

  def default_setting_keys
    res = []
    default_settings.each do |s|
      res.push s.first[:key]
    end
    res
  end
end
