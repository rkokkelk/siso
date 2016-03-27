# Be sure to restart your server when you modify this file.
include ConfigHelper

# The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
Rails.application.config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
Rails.application.config.i18n.default_locale = :en

begin
  I18n.locale = get_config('LOCALE')
rescue Exception
  I18n.locale =  I18n.default_locale
end