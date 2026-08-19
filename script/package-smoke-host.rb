# frozen_string_literal: true

require "rails"
require "action_controller/railtie"
require "propshaft"
require "propshaft/railtie"
require "imagusu/design_system"

class PackageSmokeApplication < Rails::Application
  config.load_defaults "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}"
  config.eager_load = true
  config.secret_key_base = "imagusu-design-system-package-smoke"
  config.logger = Logger.new(nil)
end

PackageSmokeApplication.initialize!
PackageSmokeApplication.eager_load!

logical_stylesheet = "imagusu_design_system/skins/default.css"
stylesheet_asset = PackageSmokeApplication.assets.load_path.find(logical_stylesheet)
abort "packaged default skin is not discoverable by Propshaft" unless stylesheet_asset

PackageSmokeApplication.assets.processor.process
digested_stylesheet = stylesheet_asset.digested_path.to_s
compiled_stylesheet = PackageSmokeApplication.config.assets.output_path.join(digested_stylesheet)
abort "Propshaft did not write the digested default skin" unless compiled_stylesheet.file?

manifest_entry = Propshaft::Manifest.from_path(PackageSmokeApplication.config.assets.manifest_path)[logical_stylesheet]
unless manifest_entry&.digested_path == digested_stylesheet
  abort "Propshaft manifest does not map the default skin to its digest"
end

runtime_dependencies = Gem.loaded_specs.fetch("imagusu_design_system").runtime_dependencies.map(&:name).sort
abort "packaged gem has unexpected runtime dependencies: #{runtime_dependencies.join(", ")}" unless runtime_dependencies == ["railties"]
abort "ViewComponent loaded in isolated host" if Gem.loaded_specs.key?("view_component")
abort "Lookbook loaded in isolated host" if Gem.loaded_specs.key?("lookbook")

locale_filenames = I18n.load_path.map { |path| File.basename(path) }
%w[imagusu_design_system.en.yml imagusu_design_system.ru.yml].each do |filename|
  abort "packaged locale is not discoverable: #{filename}" unless locale_filenames.include?(filename)
end

view_context = Class.new(ActionController::Base).new.view_context
stylesheet_tag = view_context.stylesheet_link_tag("imagusu_design_system/skins/default")
unless stylesheet_tag.scan(%r{<link\b}).one? &&
    stylesheet_tag.include?(%(/assets/#{digested_stylesheet})) &&
    !stylesheet_tag.include?("<script")
  abort "packaged default skin did not produce one digested stylesheet link"
end
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
