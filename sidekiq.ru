require 'sidekiq'
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
    username == ENV.fetch('WORKER_USERNAME') && password == ENV.fetch('WORKER_PASSWORD')
  end

  run Sidekiq::Web
end
