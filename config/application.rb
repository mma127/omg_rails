require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OMGRails
  class Application < Rails::Application
    Rails.application.configure do
      # Initialize configuration defaults for originally generated Rails version.
      config.load_defaults 6.1

      # Configuration for the application, engines, and railties goes here.
      #
      # These settings can be overridden in specific environments using the files
      # in config/environments, which are processed later.
      #
      # config.time_zone = "Central Time (US & Canada)"
      # config.eager_load_paths << Rails.root.join("extras")
    end

    config.active_support.disable_to_s_conversion = true
  end
end
