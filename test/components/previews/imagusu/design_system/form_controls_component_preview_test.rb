# frozen_string_literal: true

require "test_helper"
require_relative "form_controls_component_preview"

class Imagusu::DesignSystem::FormControlsComponentPreviewTest < ViewComponent::TestCase
  def test_default_preview_renders_complete_native_form
    render_preview(:default, from: Imagusu::DesignSystem::FormControlsComponentPreview)

    assert_selector "form"
    assert_selector "input[type='email']"
    assert_selector "textarea"
    assert_selector "select"
    assert_selector "input[type='checkbox']"
    assert_selector "fieldset input[type='radio']", count: 2
    assert_selector "button[type='submit']"
  end

  def test_error_preview_connects_each_invalid_control
    render_preview(:errors, from: Imagusu::DesignSystem::FormControlsComponentPreview)

    assert_selector "[aria-invalid='true']", minimum: 5
    assert_selector ".ids-field__error", count: 5
  end
end
