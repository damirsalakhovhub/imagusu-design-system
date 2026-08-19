# frozen_string_literal: true

require "fileutils"
require "tmpdir"
require "test_helper"
require_relative "../../script/policy_verifier"

class VerifyPolicyTest < Minitest::Test
  def setup
    @root = Pathname(Dir.mktmpdir("ids-policy"))
    write("imagusu_design_system.gemspec", <<~RUBY)
      Gem::Specification.new do |spec|
        spec.name = "imagusu-design-system"
        spec.version = "0.1.0"
        spec.add_dependency "railties", ">= 8.0"
      end
    RUBY
  end

  def teardown
    FileUtils.remove_entry(@root)
  end

  def test_accepts_the_rails_native_baseline
    assert_empty verifier.errors
  end

  def test_repository_matches_the_policy
    repository_root = Pathname(__dir__).join("../..").expand_path

    assert_empty IDS::PolicyVerifier.new(repository_root).errors
  end

  def test_rejects_an_unapproved_runtime_dependency
    write("imagusu_design_system.gemspec", <<~RUBY)
      Gem::Specification.new do |spec|
        spec.add_dependency "railties"
        spec.add_dependency "new_framework"
      end
    RUBY

    assert_includes verifier.errors, "unapproved runtime dependencies: new_framework"
  end

  def test_reads_parenthesized_runtime_dependencies
    write("imagusu_design_system.gemspec", <<~RUBY)
      Gem::Specification.new do |spec|
        spec.name = "imagusu-design-system"
        spec.version = "0.1.0"
        spec.add_dependency("railties")
        spec.add_dependency("new_framework")
      end
    RUBY

    assert_includes verifier.errors, "unapproved runtime dependencies: new_framework"
    refute_includes verifier.errors, "required runtime dependencies missing: railties"
  end

  def test_rejects_a_frontend_manifest
    write("package.json", "{}\n")

    assert_includes verifier.errors, "unapproved frontend manifests: package.json"
  end

  def test_rejects_javascript_without_an_implementation_gate
    write("app/javascript/controllers/menu_controller.js", "export default class {}\n")

    assert_includes verifier.errors,
      "frontend files require an approved implementation gate: app/javascript/controllers/menu_controller.js"
  end

  def test_rejects_plain_css_without_an_implementation_gate
    write("app/assets/stylesheets/ids.css", ".ids-button {}\n")

    assert_includes verifier.errors,
      "frontend files require an approved implementation gate: app/assets/stylesheets/ids.css"
  end

  def test_accepts_the_approved_default_skin
    write("app/assets/stylesheets/imagusu_design_system/skins/default.css", ".ids-button {}\n")

    assert_empty verifier.errors
  end

  def test_rejects_imports_in_the_approved_default_skin
    path = "app/assets/stylesheets/imagusu_design_system/skins/default.css"
    write(path, "@import 'elsewhere.css';\n")

    assert_includes verifier.errors, "approved stylesheet cannot use @import: #{path}"
  end

  def test_rejects_urls_in_the_approved_default_skin
    path = "app/assets/stylesheets/imagusu_design_system/skins/default.css"
    write(path, ".ids-button { background: url('remote.svg'); }\n")

    assert_includes verifier.errors, "approved stylesheet cannot use external or embedded URLs: #{path}"
  end

  def test_rejects_asset_pipeline_javascript_without_an_implementation_gate
    write("app/assets/javascripts/ids.js", "export {}\n")

    assert_includes verifier.errors,
      "frontend files require an approved implementation gate: app/assets/javascripts/ids.js"
  end

  def test_rejects_frontend_files_shipped_from_lib
    write("lib/imagusu/design_system/ids.css", ".ids-button {}\n")

    assert_includes verifier.errors,
      "frontend files require an approved implementation gate: lib/imagusu/design_system/ids.css"
  end

  def test_rejects_a_new_legacy_component_file
    write("app/components/new_component.rb", "class NewComponent; end\n")

    assert_includes verifier.errors,
      "app/components is forbidden by the Rails-native rendering ADR: app/components/new_component.rb"
  end

  def test_rejects_view_component_in_appraisals
    write("Appraisals", <<~RUBY)
      appraise "legacy" do
        gem "view_component"
      end
    RUBY

    assert_includes verifier.errors,
      "forbidden renderer dependencies: view_component in Appraisals"
  end

  def test_rejects_lookbook_in_the_gemfile
    write("Gemfile", <<~RUBY)
      source "https://rubygems.org"
      gem "lookbook"
    RUBY

    assert_includes verifier.errors,
      "forbidden renderer dependencies: lookbook in Gemfile"
  end

  def test_rejects_a_renderer_development_dependency_in_the_gemspec
    write("imagusu_design_system.gemspec", <<~RUBY)
      Gem::Specification.new do |spec|
        spec.name = "imagusu-design-system"
        spec.version = "0.1.0"
        spec.add_dependency "railties"
        spec.add_development_dependency("lookbook")
      end
    RUBY

    assert_includes verifier.errors,
      "forbidden renderer dependencies: lookbook in imagusu_design_system.gemspec"
  end

  def test_rejects_a_renderer_dependency_assigned_through_a_variable
    write("imagusu_design_system.gemspec", <<~RUBY)
      renderer = "view_component"
      Gem::Specification.new do |spec|
        spec.name = "imagusu-design-system"
        spec.version = "0.1.0"
        spec.add_dependency "railties"
        spec.add_development_dependency renderer
      end
    RUBY

    assert_includes verifier.errors,
      "forbidden renderer dependencies: view_component in imagusu_design_system.gemspec"
  end

  def test_rejects_an_unscoped_translation_key
    write("app/views/example.html.erb", '<%= I18n.t("actions.close") %>')

    assert_includes verifier.errors,
      "unscoped IDS translation key in app/views/example.html.erb: actions.close"
  end

  def test_rejects_an_unscoped_rails_translation_helper
    write("app/views/example.html.erb", '<%= t("actions.close") %>')

    assert_includes verifier.errors,
      "unscoped IDS translation key in app/views/example.html.erb: actions.close"
  end

  def test_rejects_the_long_form_rails_translation_helper
    write("app/views/example.html.erb", '<%= translate "actions.close" %>')

    assert_includes verifier.errors,
      "unscoped IDS translation key in app/views/example.html.erb: actions.close"
  end

  def test_rejects_an_unscoped_symbol_translation_key
    write("app/views/example.html.erb", "<%= t(:close) %>")

    assert_includes verifier.errors,
      "unscoped IDS translation key in app/views/example.html.erb: close"
  end

  def test_accepts_a_scoped_quoted_symbol_translation_key
    write("app/views/example.html.erb", '<%= t(:"imagusu_design_system.actions.close") %>')

    assert_empty verifier.errors
  end

  def test_accepts_a_scoped_translation_key
    write("app/views/example.html.erb", <<~ERB)
      <%= I18n.t("imagusu_design_system.actions.close") %>
      <%= t("imagusu_design_system.actions.close") %>
    ERB

    assert_empty verifier.errors
  end

  private

  def verifier
    IDS::PolicyVerifier.new(@root)
  end

  def write(path, contents)
    absolute_path = @root.join(path)
    absolute_path.dirname.mkpath
    absolute_path.write(contents)
  end
end
