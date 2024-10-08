require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Changologs
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    # config.assets.initialize_on_precompile = false
    # config.eager_load = true
    # config.eager_load_paths += %W(#{config.root}/app/lib)
    config.time_zone = 'Pacific Time (US & Canada)'
    config.active_record.default_timezone = :utc
  end
end
