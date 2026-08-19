# frozen_string_literal: true

require_relative "lib/imagusu/design_system/version"

Gem::Specification.new do |spec|
  spec.name = "imagusu_design_system"
  spec.version = Imagusu::DesignSystem::VERSION
  spec.authors = ["Damir Salakhov"]
  spec.email = ["damirsalakhov@gmail.com"]

  spec.summary = "Server-rendered UI components for Imagusu Rails applications"
  spec.description = "Imagusu Design System packages accessible, reusable ViewComponents for Ruby on Rails."
  spec.homepage = "https://github.com/damirsalakhovhub/imagusu-design-system"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.3", "< 4.1")

  spec.metadata = {
    "allowed_push_host" => "https://rubygems.org",
    "changelog_uri" => "#{spec.homepage}/blob/main/CHANGELOG.md",
    "documentation_uri" => "#{spec.homepage}/tree/main/docs",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => spec.homepage
  }

  spec.files = Dir[
    "app/**/*",
    "lib/**/*",
    "CHANGELOG.md",
    "LICENSE.txt",
    "README.md"
  ]
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 8.0", "< 8.2"
  spec.add_dependency "view_component", ">= 4.0", "< 5"

  spec.add_development_dependency "appraisal", "~> 2.5"
  spec.add_development_dependency "capybara", "~> 3.40"
  spec.add_development_dependency "minitest", "~> 6.0"
  spec.add_development_dependency "rails", ">= 8.0", "< 8.2"
  spec.add_development_dependency "rake", "~> 13.2"
  spec.add_development_dependency "standard", "~> 1.50"
end
