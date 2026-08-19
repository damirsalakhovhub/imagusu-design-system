# frozen_string_literal: true

require "test_helper"

class Imagusu::DesignSystem::BadgeComponentTest < ViewComponent::TestCase
  def test_renders_neutral_badge_by_default
    render_inline(component) { "Draft" }

    assert_selector "span.ids-badge[data-tone='neutral']", text: "Draft"
  end

  def test_renders_semantic_tone_and_safe_attributes
    render_inline(component(
      tone: :success,
      classes: "release-status",
      html_attributes: {title: "Published", data: {controller: "badge"}}
    )) { "Ready" }

    assert_selector "span.ids-badge.release-status[data-tone='success'][data-controller='badge'][title='Published']", text: "Ready"
  end

  def test_escapes_content
    render_inline(component) { "<img src=x onerror=alert(1)>" }

    assert_no_selector "img"
    assert_text "<img src=x"
  end

  def test_rejects_unknown_tone_and_owned_data
    assert_raises(ArgumentError) { component(tone: :critical) }
    assert_raises(ArgumentError) { component(html_attributes: {data: {tone: "danger"}}) }
    assert_raises(ArgumentError) { component(html_attributes: {onclick: "alert(1)"}) }
  end

  private

  def component(**attributes)
    Imagusu::DesignSystem::BadgeComponent.new(**attributes)
  end
end
