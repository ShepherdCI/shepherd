require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Shepherd
  class Application < Rails::Application
    config.load_defaults 5.1

    paths = %W[
      #{config.root}/lib
    ]

    config.autoload_paths   +=  paths
    config.eager_load_paths +=  paths

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
