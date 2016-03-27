# Be sure to restart your server when you modify this file.
include ConfigHelper

I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

begin
  locale = get_config('LOCALE')
rescue Exception
end

I18n.default_locale = locale || :en