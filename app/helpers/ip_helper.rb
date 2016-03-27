require 'netaddr'

module IpHelper

  def IpHelper.createCIDR(config_range)
    @ranges ||= []
    #raise SystemExit, 'No IP whitelist specified' unless config_range

    config_range.split(',').each do |range|
      range.strip!
      begin
        @ranges << NetAddr::CIDR.create(range)
        Rails.logger.info {"IP range added to whitelist: #{range}"}
      rescue
        Rails.logger.warn {"Error parsing IP range: #{range}"}
      end
    end
  end

  def IpHelper.verifyIP(ip)
    Rails.logger.debug{"Current ip (#{ip}), Ranges (#{@ranges})"}
    @ranges.each do |range|
      begin
        if range.matches? ip then return true end
      rescue NetAddr::ValidationError
        # Error is thrown when IPv4 is compared with IPv6,
        # not fatal so continue
        next
      end
    end
    false
  end
end

