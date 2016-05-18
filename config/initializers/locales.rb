# Be sure to restart your server when you modify this file.
include ConfigHelper

I18n.default_locale = get_config('LOCALE') || :en
I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]