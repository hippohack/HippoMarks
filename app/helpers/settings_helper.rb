module SettingsHelper
  def setting_home_url
    home_url = current_account.settings.find_by(key: :home_url)
    home_url.present? ? home_url.value : '/'
  end
end
