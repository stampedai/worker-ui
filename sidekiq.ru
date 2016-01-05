require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq-status/web'
require 'sidekiq-statistic'
require 'sidetiq/web'

Sidekiq.configure_client do |config|
  config.redis = {
    size: 1,
    namespace: 'sidekiq',
    url: ENV.fetch('REDIS_URL') { 'redis://localhost:6379' }
  }
end

map '/sidekiq' do
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == ENV.fetch('SIDEKIQ_USERNAME') && password == ENV.fetch('SIDEKIQ_PASSWORD')
  end

  run Sidekiq::Web
end
