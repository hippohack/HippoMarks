module SettingsHelper
  def setting_home_url
    current_account.settings.find_by(key: :home_url).value
  end
end
