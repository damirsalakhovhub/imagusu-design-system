# frozen_string_literal: true

require "test_helper"
require_relative "core_components_component_preview"

class Imagusu::DesignSystem::CoreComponentsComponentPreviewTest < ViewComponent::TestCase
  def test_default_preview_renders_core_primitives
    render_preview(:default, from: Imagusu::DesignSystem::CoreComponentsComponentPreview)

    assert_selector "a.ids-link"
    assert_selector ".ids-badge"
    assert_selector ".ids-alert"
    assert_selector ".ids-error-summary"
    assert_selector "article.ids-card"
  end

  def test_tones_preview_renders_all_tones
    render_preview(:tones, from: Imagusu::DesignSystem::CoreComponentsComponentPreview)

    assert_selector ".ids-badge", count: Imagusu::DesignSystem::BadgeComponent::TONES.length
    assert_selector ".ids-alert", count: Imagusu::DesignSystem::AlertComponent::TONES.length
  end

  def test_form_controls_preview_renders_group_and_upload
    render_preview(:form_controls, from: Imagusu::DesignSystem::CoreComponentsComponentPreview)

    assert_selector ".ids-checkbox-group input[type='checkbox']", count: 2
    assert_selector "input.ids-file-upload[type='file']"
  end
end
