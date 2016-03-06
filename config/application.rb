require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Siso
  class Application < Rails::Application

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.exceptions_app = self.routes

    config.cache_store = :memory_store

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Middleware against brute-force attack etc.
    config.middleware.use Rack::Attack

    # Default HTTP headers
    config.action_dispatch.default_headers = {
        'X-Frame-Options' => 'SAMEORIGIN',
        'X-XSS-Protection' => '1; mode=block',
        'X-Content-Type-Options' => 'nosniff',
        'Cache-Control' => 'no-store, no-cache',
        'Content-Security-Policy' => "default-src 'none'; script-src 'self'; img-src 'self'; style-src 'self';"
    }
  end
end
