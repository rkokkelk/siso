# Be sure to restart your server when you modify this file.

class Rack::Attack

  cache.store = ActiveSupport::Cache::MemoryStore.new

  # Throttle login attempts for a given ip to 20 reqs/minute
  # Return the IP as a discriminator on POST /repository/ID/authenticate requests
  throttle('Repository authentication', :limit => 20, :period => 60.seconds) do |req|

    # Verify correct URL: /repositories/:id/authenticate
    unless (req.path =~ /\A\/repositories\/[\da-f]+\/authenticate\z/).nil?
      req.ip if req.post?
    end
  end

  # Logging
  ActiveSupport::Notifications.subscribe('rack.attack') do |name, start, finish, request_id, req|
    Rails.logger.warn{"Bruteforce detected: IP:(#{req.ip}), Start:(#{start.to_s(:date_time_ms)}), Finished:(#{finish.to_s(:date_time_ms)})"}
  end
end
