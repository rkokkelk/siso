require 'netaddr'

module IpHelper

  @ranges ||= []

  def IpHelper.createCIDR(config_range)
    @ranges ||= []
    config_range.split(',').each do |range|
      range.strip!
      begin
        @ranges << NetAddr::CIDR.create(range)
        Rails.logger.info{"IP range added to whitelist: #{range}"}
      rescue
        Rails.logger.warn{"Error parsing IP range: #{range}"}
      end
    end
  end

  def IpHelper.verifyIP(ip)
    Rails.logger.debug{"Current ip (#{ip}), Ranges (#{@ranges})"}
    @ranges.each do |range|
      if range.matches? ip then return true end
    end
    false
  end
end

