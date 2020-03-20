require 'digest'
require 'active_support/security_utils'

if ENV["SIDEKIQ_PRO_KEY"] && ENV["SIDEKIQ_PRO_KEY"] != ""
  require 'sidekiq-pro'
  require 'sidekiq/pro/web'
else
  require 'sidekiq'
  require 'sidekiq/web'
end

require 'sidekiq/cron/web'

# @see https://github.com/mperham/sidekiq/wiki/Monitoring
Sidekiq.configure_client do |config|
  config.redis = {
    size: 1,
    url: ENV.fetch('REDIS_URL') { 'redis://localhost:6379' }
  }
end

map '/' do
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    # Protect against timing attacks:
    # - See https://codahale.com/a-lesson-in-timing-attacks/
    # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
    # - Use & (do not use &&) so that it doesn't short circuit.
    # - Use digests to stop length information leaking
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_USERNAME'))) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_PASSWORD')))
  end

  run Sidekiq::Web
end
