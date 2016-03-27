# Be sure to restart your server when you modify this file.
# This initializer generate the CIDR list for the configured IP whitelist
include ConfigHelper

IpHelper.createCIDR get_config('IP_WHITE_LIST')