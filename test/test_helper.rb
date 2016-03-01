ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require "codeclimate-test-reporter"
require 'rails/test_help'
require 'securerandom'
require 'yaml'


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Add more helper methods to be used by all tests here...
  
  # Start codeclimate testreporter
  CodeClimate::TestReporter.start

  # Load IP helper
  APP_CONFIG = YAML.load_file(Rails.root.join('config/config.yml'))
  IpHelper.createCIDR APP_CONFIG['IP_range']

  def get_id_from_url(url)
    url.split('/')[-1]
  end

  def generate_titles
    SecureRandom.hex 20
  end

  def generate_description
    content = SecureRandom.hex 20
    content += ' '
    content += SecureRandom.hex 20
    content
  end

  def generate_file_name
    SecureRandom.hex 10 + '.file'
  end
end
