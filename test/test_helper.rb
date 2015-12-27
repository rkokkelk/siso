ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'yaml'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Add more helper methods to be used by all tests here...

  # Load IP helper
  APP_CONFIG = YAML.load_file(Rails.root.join('config/config.yml'))
  IpHelper.createCIDR APP_CONFIG['IP_range']
end
