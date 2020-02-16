class SettingsController < ApplicationController
  before_action :set_setting, :set_locale

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

    # 並び順制御
    # TODO: 項目が増えたら要調整
    sort_keys = [
      'lang',
      'home_url',
      'show_many_visits',
      'many_visits_num',
      'show_history',
      'history_num',
      'item_sort',
      'show_bookmarklet'
    ]

    settings = @settings
    @settings = []
    sort_keys.each do |key|
      @settings.push settings.find_by(key: key)
    end

    render :edit
  end

  def edit
    
  end

  def update
    params.fetch(:setting, {}).each do |key, param|
      setting = @settings.find_by(key: param[:key])
      setting.update!(setting_attributes(param))
      flash[:notice] = 'Updated system settings.'
    end
    redirect_to settings_path
  end

  def item_sort
    propaties = SortMaster.all.pluck(:slug)
    return if propaties.include?(params[:value]) == false

    setting = current_account.settings.find_by(key: 'item_sort')
    setting.value = params[:value]

    redirect_to root_path if setting.save
  end

  def hide_bookmarklet
    setting = current_account.settings.find_by(key: 'show_bookmarklet')

    if setting.blank?
      setting = current_account.settings.new(
        key: 'show_bookmarklet'
      )
    end

    setting.value = 'false'

    setting.save
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
      [key: 'lang', value: 'english'],
      [key: 'home_url', value: '/'],
      [key: 'show_many_visits', value: 'true'],
      [key: 'many_visits_num', value: '10'],
      [key: 'show_history', value: 'true'],
      [key: 'history_num', value: '10'],
      [key: 'item_sort', value: 'optional'],
      [key: 'show_bookmarklet', value: 'true']
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
