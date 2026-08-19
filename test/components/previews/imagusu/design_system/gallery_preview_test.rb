# frozen_string_literal: true

require "test_helper"
require_relative "gallery_preview"

class Imagusu::DesignSystem::GalleryPreviewTest < ViewComponent::TestCase
  def test_default_preview_renders_every_public_component
    render_preview(:default, from: Imagusu::DesignSystem::GalleryPreview)

    assert_selector "button", text: "Button"
    assert_selector "a.ids-link", text: "Link"
    assert_selector ".ids-badge", text: "Badge"
    assert_selector ".ids-alert__body", text: "Alert message"
    assert_selector ".ids-card"
    assert_selector ".ids-error-summary"
    assert_selector ".ids-field"
    assert_selector "input.ids-input"
    assert_selector "textarea.ids-textarea"
    assert_selector "select.ids-select"
    assert_selector "input.ids-checkbox__control"
    assert_selector ".ids-checkbox-group"
    assert_selector ".ids-radio-group"
    assert_selector "input.ids-file-upload"
  end
end
