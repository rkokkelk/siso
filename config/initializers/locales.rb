# Be sure to restart your server when you modify this file.
I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
I18n.default_locale = Rails.configuration.x.config['LOCALE'] || :en