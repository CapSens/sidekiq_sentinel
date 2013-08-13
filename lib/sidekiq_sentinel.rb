require "sidekiq_sentinel/version"

module Sidekiq
  class RedisConnection
    class << self
      alias :origin_client_opts :client_opts
      def client_opts(url, driver, timeout)
        return origin_client_opts(url, driver, timeout) unless Sidekiq.options[:sentinel]
        require 'redis-sentinel'
        opts = {
          :url => url,
          :driver => driver,
          :master_name => Sidekiq.options[:sentinel][:master_name],
          :sentinels => Sidekiq.options[:sentinel][:sentinels]
          }
        if timeout
          opts.merge!({ :timeout => timeout })
        end
        opts
      end
    end
  end
end