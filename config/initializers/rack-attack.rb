# be sure to restart your server when you modify this file.

module Rack
  class Attack
    cache.store = ActiveSupport::Cache::MemoryStore.new

    # Throttle login attempts for a given ip to 20 reqs/minute
    # Return the IP as a discriminator on POST /:id/authenticate requests
    throttle('Repository authentication (IP)', limit: 20, period: 60.seconds) do |req|
      # Verify correct URL: /:id/authenticate
      req.ip if req.post? && req.path =~ /\A\/[\da-f]+\/authenticate\z/
    end

    # Throttle login attempts for a given repository to 20 reqs/minute
    # Return the repository token as a discriminator on POST /:id/authenticate requests
    throttle('Repository authentication (Token)', limit: 20, period: 60.seconds) do |req|
      # Verify correct URL: /:id/authenticate
      req.params[:id] if req.post? && req.path =~ /\A\/[\da-f]+\/authenticate\z/
    end

    # Throttle creation of repositories to 30 reqs/minute
    # Return the IP as a discriminator on POST /create requests
    throttle('Creation repository', limit: 30, period: 60.seconds) do |req|
      # Verify correct URL: /:id/authenticate
      req.ip if req.post? && req.path =~ /\A\/create\z/
    end

    # Logging
    ActiveSupport::Notifications.subscribe('rack.attack') do |_name, start, finish, _request_id, req|
      Rails.logger.warn { "Bruteforce detected (#{_name}) IP:[#{req.ip}], Start:[#{start.to_s(:date_time_ms)}], Finished:[(]#{finish.to_s(:date_time_ms)}]" }
    end
  end
end
