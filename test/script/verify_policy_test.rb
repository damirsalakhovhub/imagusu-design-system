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
        spec.add_dependency "view_component", ">= 4.0"
      end
    RUBY
    write("script/policy/view_component_files.txt", "app/components/legacy_component.rb\n")
    write("app/components/legacy_component.rb", "class LegacyComponent; end\n")
  end

  def teardown
    FileUtils.remove_entry(@root)
  end

  def test_accepts_the_transitional_baseline
    assert_empty verifier.errors
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

  def test_rejects_javascript_before_an_architecture_decision
    write("app/javascript/controllers/menu_controller.js", "export default class {}\n")

    assert_includes verifier.errors,
      "frontend files cannot ship before an architecture decision: app/javascript/controllers/menu_controller.js"
  end

  def test_rejects_plain_css_before_an_architecture_decision
    write("app/assets/stylesheets/ids.css", ".ids-button {}\n")

    assert_includes verifier.errors,
      "frontend files cannot ship before an architecture decision: app/assets/stylesheets/ids.css"
  end

  def test_rejects_asset_pipeline_javascript_before_an_architecture_decision
    write("app/assets/javascripts/ids.js", "export {}\n")

    assert_includes verifier.errors,
      "frontend files cannot ship before an architecture decision: app/assets/javascripts/ids.js"
  end

  def test_rejects_a_new_legacy_component_file
    write("app/components/new_component.rb", "class NewComponent; end\n")

    assert_includes verifier.errors,
      "new legacy component files are forbidden during migration: app/components/new_component.rb"
  end

  def test_allows_deleting_a_legacy_component
    FileUtils.rm(@root.join("app/components/legacy_component.rb"))

    assert_empty verifier.errors
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
