require 'netaddr'

module IpHelper

  @ranges = []

  def IpHelper.createCIDR(ranges)
    ranges.split(',').each do |range|

      begin
        @ranges << NetAddr::CIDR.create(range.strip)
        Rails.logger.info{"Following IP range in whitelist: #{range}"}
      rescue
        Rails.logger.warn{"Error parsing following IP: #{range}"}
      end
    end
  end

  def IpHelper.verifyIP(ip)
    @ranges.each do |range|
      if range.matches?(ip) then return true end
    end
    false
  end
end

