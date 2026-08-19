# frozen_string_literal: true

require "test_helper"
require "yaml"

class LocalizationTest < ActiveSupport::TestCase
  PLURAL_CATEGORIES = %w[zero one two few many other].freeze
  LOCALE_DIRECTORY = Pathname(__dir__).join("../config/locales").expand_path
  ENGLISH_PATH = LOCALE_DIRECTORY.join("imagusu_design_system.en.yml")
  RUSSIAN_PATH = LOCALE_DIRECTORY.join("imagusu_design_system.ru.yml")
  LOCALE_PATHS = [ENGLISH_PATH, RUSSIAN_PATH].freeze

  test "engine exposes the bundled English and Russian locales" do
    expanded_load_path = I18n.load_path.map { |path| Pathname(path).expand_path }

    LOCALE_PATHS.each { |path| assert_includes expanded_load_path, path }
  end

  test "English and Russian owned keys are complete and nonblank" do
    english = flattened_values(ENGLISH_PATH, "en")
    russian = flattened_values(RUSSIAN_PATH, "ru")

    assert_equal english.keys.sort, russian.keys.sort
    assert english.values.all? { |value| value.is_a?(String) && value.strip.present? }
    assert russian.values.all? { |value| value.is_a?(String) && value.strip.present? }
    english.each_key do |key|
      assert_equal interpolation_keys(english.fetch(key)), interpolation_keys(russian.fetch(key)), key
    end
  end

  test "owned plural maps wait for an approved Russian plural rule strategy" do
    {"en" => ENGLISH_PATH, "ru" => RUSSIAN_PATH}.each do |locale, path|
      assert_empty pluralization_paths(locale_tree(path, locale)), locale
    end
  end

  private

  def flattened_values(path, locale)
    flatten(locale_tree(path, locale))
  end

  def locale_tree(path, locale)
    YAML.safe_load_file(path).fetch(locale).fetch("imagusu_design_system")
  end

  def flatten(value, prefix = nil)
    value.each_with_object({}) do |(key, child), result|
      path = [prefix, key].compact.join(".")
      if child.is_a?(Hash)
        result.merge!(flatten(child, path))
      else
        result[path] = child
      end
    end
  end

  def interpolation_keys(value)
    value.scan(/%\{([^}]+)\}/).flatten.sort
  end

  def pluralization_paths(value, prefix = nil)
    return [] unless value.is_a?(Hash)

    keys = value.keys.map(&:to_s)
    paths = if keys.include?("other") && (keys - PLURAL_CATEGORIES).empty?
      [prefix || "<root>"]
    else
      []
    end

    value.each do |key, child|
      child_prefix = [prefix, key].compact.join(".")
      paths.concat(pluralization_paths(child, child_prefix))
    end

    paths
  end
end
