# be sure to restart your server when you modify this file.

class Rack::Attack
  cache.store = ActiveSupport::Cache::MemoryStore.new

  # Throttle login attempts for a given ip to 20 reqs/minute
  # Return the IP as a discriminator on POST /:id/authenticate requests
  throttle('Repository authentication', limit: 20, period: 60.seconds) do |req|
    # Verify correct URL: /:id/authenticate
      req.ip if req.post? && req.path =~ /\A\/[\da-f]+\/authenticate\z/
  end

  # Logging
  ActiveSupport::Notifications.subscribe('rack.attack') do |_name, start, finish, _request_id, req|
    Rails.logger.warn { "Bruteforce detected: IP:(#{req.ip}), Start:(#{start.to_s(:date_time_ms)}), Finished:(#{finish.to_s(:date_time_ms)})" }
  end
end
