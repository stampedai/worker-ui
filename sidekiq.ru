require 'active_support/logger'

require 'sidekiq'
require 'sidekiq-status'
require 'sidekiq/web'
require 'sidekiq-status/web'

Sidekiq.configure_client do |config|
  config.redis = {
    size: 1,
    namespace: "dialog_#{ENV.fetch('RAILS_ENV')}",
    url: ENV.fetch('REDIS_URL') { 'redis://localhost:6379' }
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
