ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'codeclimate-test-reporter'
require 'rails/test_help'
require 'securerandom'
require 'fileutils'

module ActiveSupport
  class TestCase
    include ConfigHelper

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
    # Start codeclimate testreporter
    CodeClimate::TestReporter.start

    # Load IP helper
    IpHelper.create_CIDR get_config('IP_WHITE_LIST')

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

    def setup
      @@files = Dir[Rails.root.join('data', '*')]
    end

    def teardown
      files = Dir[Rails.root.join('data', '*')]
      files.each do |file_name|
        unless @@files.include? file_name
          FileUtils.rm Rails.root.join('data', file_name)
        end
      end
    end
  end
end
