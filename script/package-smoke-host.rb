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

view_context = Class.new(ActionController::Base).new.view_context
component = Imagusu::DesignSystem::ButtonComponent.new(type: :submit).with_content("Package smoke")
rendered = component.render_in(view_context)

abort "packaged component did not render" unless rendered.include?(%(<button type="submit">Package smoke</button>))

form = ActionView::Helpers::FormBuilder.new(:profile, nil, view_context, {})
field = Imagusu::DesignSystem::TextFieldComponent.new(
  form: form,
  method: :email,
  type: :email,
  label: "Email",
  errors: false
)
rendered_field = field.render_in(view_context)

unless rendered_field.include?(%(<input)) && rendered_field.include?(%(type="email")) && rendered_field.include?(%(name="profile[email]"))
  abort "packaged form component did not render"
end

alert = Imagusu::DesignSystem::AlertComponent.new(title: "Package smoke", tone: :success).with_content("Ready")
rendered_alert = alert.render_in(view_context)

unless rendered_alert.include?(%(class="ids-alert")) && rendered_alert.include?(%(data-tone="success"))
  abort "packaged primitive component did not render"
end
