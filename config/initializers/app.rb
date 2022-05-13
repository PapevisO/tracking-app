# frozen_string_literal: true

# 1/ check if ENV key exist then validate and set
# 2/ if no check in credentials then validate and set
# 3/ if no generate display warning, raise error in production, and set

TrackingApp::App.define do |config|
  # General configuration ---------------------------------------------
  # https://www.openware.com/sdk/docs/barong/configuration.html#general-configuration
  config.set(:app_name, 'App')
  config.set(:domain, 'tracker-app.papievis.com')
  config.set(:geoip_lang, 'en', values: %w[en de es fr ja ru])
  config.set(:maxminddb_path, '', type: :path)
  config.set(:rabbitmq_host, 'localhost')
  config.set(:rabbitmq_port, '5672')
  config.set(:rabbitmq_username, 'guest')
  config.set(:rabbitmq_password, 'guest')
  config.set(:redis_url, 'redis://localhost:6379/1')
  config.set(:redis_password, '')
  config.set(:default_language, 'en')
end

TrackingApp::GeoIP.lang = TrackingApp::App.config.geoip_lang
