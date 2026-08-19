# frozen_string_literal: true

require "rails"
require "action_controller/railtie"
require "imagusu/design_system"

class PackageSmokeApplication < Rails::Application
  config.load_defaults "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}"
  config.eager_load = true
  config.secret_key_base = "imagusu-design-system-package-smoke"
  config.logger = Logger.new(nil)
end

PackageSmokeApplication.initialize!
PackageSmokeApplication.eager_load!

runtime_dependencies = Gem.loaded_specs.fetch("imagusu_design_system").runtime_dependencies.map(&:name).sort
abort "packaged gem has unexpected runtime dependencies: #{runtime_dependencies.join(", ")}" unless runtime_dependencies == ["railties"]
abort "ViewComponent loaded in isolated host" if Gem.loaded_specs.key?("view_component")
abort "Lookbook loaded in isolated host" if Gem.loaded_specs.key?("lookbook")

view_context = Class.new(ActionController::Base).new.view_context
native_button = view_context.render(
  partial: "imagusu/design_system/button",
  locals: {content: "Native package smoke", type: :submit}
)

unless native_button.include?(%(<button)) &&
    native_button.include?(%(class="ids-button")) &&
    native_button.include?(%(type="submit")) &&
    native_button.include?(%(">Native package smoke</button>))
  abort "packaged Rails-native button partial did not render"
end

native_form = ActionView::Helpers::FormBuilder.new(:profile, nil, view_context, {})
native_field = view_context.render(
  partial: "imagusu/design_system/text_field",
  locals: {form: native_form, method: :email, label: "Email", type: :email}
)

unless native_field.include?(%(<input)) &&
    native_field.include?(%(id="profile_email")) &&
    native_field.include?(%(class="ids-input")) &&
    native_field.include?(%(type="email")) &&
    native_field.include?(%(name="profile[email]"))
  abort "packaged Rails-native text field partial did not render"
end
