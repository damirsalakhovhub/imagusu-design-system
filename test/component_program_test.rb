# frozen_string_literal: true

require "test_helper"
require "yaml"

class ComponentProgramTest < ActiveSupport::TestCase
  ROOT = Pathname(__dir__).join("..").expand_path
  CATALOG_PATH = ROOT.join("docs/components/catalog.md")
  SKILL_PATH = ROOT.join(".agents/skills/ids-component-program/SKILL.md")
  REQUIRED_PATHS = %w[
    AGENTS.md
    docs/architecture/0007-component-program.md
    docs/components/catalog.md
    docs/process/component-development.md
    docs/quality/component-testing.md
    .agents/skills/ids-component-program/SKILL.md
  ].freeze

  test "component program files exist" do
    REQUIRED_PATHS.each { |path| assert ROOT.join(path).file?, path }
  end

  test "the catalog has exactly one current family" do
    current_rows = CATALOG_PATH.readlines.grep(/\|\s*▶\s*\|/)

    assert_equal 1, current_rows.size
    assert_match(/\|\s*1\s*\|\s*▶\s*\|\s*Button\s*\|/, current_rows.first)
  end

  test "the repo-local skill has portable frontmatter" do
    contents = SKILL_PATH.read
    frontmatter = contents.match(/\A---\n(.+?)\n---/m)

    refute_nil frontmatter
    metadata = YAML.safe_load(frontmatter[1])
    assert_equal "ids-component-program", metadata.fetch("name")
    assert metadata.fetch("description").present?
    refute_match(%r{/Users/}, contents)
  end
end
