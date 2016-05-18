# Be sure to restart your server when you modify this file.
# This initializer generate the CIDR list for the configured IP whitelist
include IpHelper
include ConfigHelper

create_CIDR get_config('IP_WHITE_LIST')