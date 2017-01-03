require 'active_support/logger'
require 'active_support/core_ext/hash'

require 'sidekiq'
require 'sidekiq/web'

# Use separate databases per environment and application
REDISDB = {
  app: {
    development: 1,
    test: 2,
    production: 3
  },
  sidekiq: {
    development: 4,
    test: 5,
    production: 6
  }
}.with_indifferent_access.freeze

redis_url = URI.join(ENV.fetch('REDIS_URL') { 'redis://localhost:6379' }, REDISDB.dig(:sidekiq, ENV.fetch('RAILS_ENV')).to_s).to_s

Sidekiq.configure_client do |config|
  config.redis = {
    size: 1,
    url: redis_url
  }
end

map '/sidekiq' do
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    # Protect against timing attacks: (https://codahale.com/a-lesson-in-timing-attacks/)
    # - Use & (do not use &&) so that it doesn't short circuit.
    # - Use digests to stop length information leaking
    Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV.fetch('WORKER_USERNAME'))) &
      Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV.fetch('WORKER_PASSWORD')))
  end

  run Sidekiq::Web
end

# Log both to STDOUT (by default) and to "log/thin.log"
file_logger = Logger.new("log/thin.log")
Thin::Logging.logger.extend(::ActiveSupport::Logger.broadcast(file_logger))
