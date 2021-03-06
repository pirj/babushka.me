require File.expand_path('../boot', __FILE__)
require 'rails/all'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module BabushkaMe

  REFSPEC = `git rev-parse --short HEAD 2>/dev/null`.strip

  class Application < Rails::Application
    config.autoload_paths += %W[#{config.root}/lib]
    config.filter_parameters += [:password]
    config.active_record.schema_format = :sql
  end
end
