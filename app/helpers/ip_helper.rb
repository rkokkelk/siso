require 'netaddr'

module IpHelper

  @@ranges ||= []

  def createCIDR(config_range)
    config_range.split(',').each do |range|
      range.strip!
      begin
        @@ranges << NetAddr::CIDR.create(range)
        Rails.logger.info { "IP range added to whitelist: #{range}" }
      rescue
        Rails.logger.warn { "Error parsing IP range: #{range}" }
      end
    end
  end

  def verifyIP(ip)
    unless @@ranges
      Rails.logger.error { "Cannot verify IP, @ranges(#{@@ranges})" }
      return false
    end

    Rails.logger.debug { "Current ip(#{ip}), @ranges(#{@@ranges})" }
    @@ranges.each do |range|
      begin
        return true if range.matches? ip
      rescue NetAddr::ValidationError
        # Error is thrown when IPv4 is compared with IPv6,
        # not fatal so continue
        next
      end
    end
    false
  end
end

