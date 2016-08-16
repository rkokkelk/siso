# be sure to restart your server when you modify this file.
require 'render_anywhere'

module Rack
  class Attack
    cache.store = ActiveSupport::Cache::MemoryStore.new

    # Always allow requests from localhost
    # (blocklist & throttles are skipped), usefull for tests
    safelist('allow from localhost') do |req|
      # Requests are allowed if the return value is truthy
      '127.0.0.1' == req.ip || '::1' == req.ip
    end

    # Throttle login attempts for a given ip to 20 reqs/minute
    # Return the IP as a discriminator on POST /:id/authenticate requests
    throttle('Repository authentication (IP)', limit: 1, period: 60.seconds) do |req|
      req.ip if req.post? && req.path =~ /\A\/[\da-f]+\/authenticate\z/
    end

    # Throttle login attempts for a given repository to 20 reqs/minute
    # Return the repository token as a discriminator on POST /:id/authenticate requests
    throttle('Repository authentication (Token)', limit: 20, period: 60.seconds) do |req|
      req.params[:id] if req.post? && req.path =~ /\A\/[\da-f]+\/authenticate\z/
    end

    # Throttle creation of repositories to 30 reqs/minute
    # Return the IP as a discriminator on POST /new requests
    throttle('Creation repository', limit: 30, period: 60.seconds) do |req|
      req.ip if req.post? && req.path =~ /\A\/new\z/
    end

    # Perform logging when throttle is fired
    ActiveSupport::Notifications.subscribe('rack.attack') do |_name, start, finish, _request_id, req|
      # No need for logging during test
      unless Rails.env.test?
        Rails.logger.warn { "Bruteforce detected (#{_name}) IP:[#{req.ip}], Start:[#{start.to_s(:date_time_ms)}], Finished:[#{finish.to_s(:date_time_ms)}]" }
      end
    end

    # Define output if throttle is fired
    self.throttled_response = lambda do |env|
      # Todo: fix reference
      html = Rack::Render.new().render(:template => 'main/server_error',
                                       :layout   => 'application')

      # Using 503 because it may make attacker think that they have successfully
      # DOSed the site. Rack::Attack returns 429 for throttling by default
      [ 503, {}, [html]]
    end
  end

  class Render
    include RenderAnywhere
  end
end
