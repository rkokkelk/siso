# Be sure to restart your server when you modify this file.
# This initializer generate the CIDR list for the configured IP whitelist
require 'yaml'

APP_CONFIG = YAML.load_file(Rails.root.join('config/config.yml'))
if ENV['IP_WHITE_LIST']
  list = ENV['IP_WHITE_LIST']
else
  list = APP_CONFIG['IP_range']
end
IpHelper.createCIDR list