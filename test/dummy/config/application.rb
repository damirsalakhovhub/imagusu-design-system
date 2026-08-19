# frozen_string_literal: true

require "rails"
require "action_controller/railtie"
require "propshaft"
require "propshaft/railtie"
require "imagusu/design_system"

module Dummy
  class Application < Rails::Application
    config.load_defaults "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}"
    config.eager_load = false
    config.secret_key_base = "imagusu-design-system-test"
    config.logger = Logger.new(nil)
    config.hosts.clear
  end
end
