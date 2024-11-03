require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Src
  class Application < Rails::Application
    config.load_defaults 7.1

    config.autoload_lib(ignore: %w(assets tasks))

    config.generators do |g|
      g.assets false
      g.helper false
    end
  end
end
