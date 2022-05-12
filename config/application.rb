require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dir[File.expand_path('../../lib/app/**/*.rb', __FILE__)].each { |file| require file }

module TrackingApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # # Eager loading app dir.
    # config.autoload_paths += Dir[Rails.root.join('app')]

    # # Eager load constants from lib
    # # There is a lot of constants used over the whole application.
    # #   lib/app/amqp/config.rb => AMQP::Config
    # config.eager_load_paths += Dir[Rails.root.join('lib/app/**')]
    # config.autoload_paths += Dir[Rails.root.join('lib/app/**')]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
