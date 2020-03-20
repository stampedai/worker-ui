ruby '2.6.5'
source 'https://rubygems.org'

gem 'activesupport', '~> 6.0'
gem 'thin', '~> 1.7'

# https://github.com/rack/rack/issues/1432
gem "rack", "2.0.8"

if ENV["SIDEKIQ_PRO_KEY"] && (ENV["SIDEKIQ_PRO_KEY"] != "")
  source "https://gems.contribsys.com/" do
    gem "sidekiq-pro", "~> 5.0"
  end
else
  gem "sidekiq", "~> 6"
end

gem "sidekiq-cron", "~> 1.1"

group :development, :test do
  gem 'dotenv'
end
