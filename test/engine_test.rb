# frozen_string_literal: true

require "test_helper"

class EngineTest < ActiveSupport::TestCase
  test "engine loads the Rails-native foundation" do
    assert_kind_of Class, Imagusu::DesignSystem::Engine
    assert_kind_of Module, Imagusu::DesignSystem::Internal::HTMLAttributes
    refute Gem.loaded_specs.key?("view_component")
    refute Gem.loaded_specs.key?("lookbook")
  end

  test "engine eager loads without a component framework" do
    Rails.application.eager_load!

    assert_kind_of Class, Imagusu::DesignSystem::Engine
  end

  test "engine exposes packaged strict-local partials" do
    view_context = Class.new(ActionController::Base).new.view_context
    rendered = view_context.render(
      partial: "imagusu/design_system/button",
      locals: {content: "Engine smoke"}
    )

    assert_includes rendered, "class=\"ids-button\""
    assert_includes rendered, ">Engine smoke</button>"
  end
end
