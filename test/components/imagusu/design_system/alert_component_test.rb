# frozen_string_literal: true

require "test_helper"

class Imagusu::DesignSystem::AlertComponentTest < ViewComponent::TestCase
  def test_renders_static_alert_without_live_region_by_default
    render_inline(component(title: "Account updated")) { "Your changes were saved." }

    assert_selector "div.ids-alert[data-tone='info']:not([role])"
    assert_selector "h2.ids-alert__title", text: "Account updated"
    assert_selector ".ids-alert__body", text: "Your changes were saved."
  end

  def test_supports_tone_heading_level_and_explicit_announcement
    render_inline(component(title: "Payment failed", tone: :danger, announce: :assertive, heading_level: 3)) { "Try again." }

    assert_selector ".ids-alert[data-tone='danger'][role='alert']"
    assert_selector "h3.ids-alert__title", text: "Payment failed"
  end

  def test_supports_polite_status
    render_inline(component(title: "Saved", announce: :polite)) { "Done" }

    assert_selector ".ids-alert[role='status']"
  end

  def test_escapes_title_and_content
    render_inline(component(title: "<Title>")) { "<script>alert(1)</script>" }

    assert_no_selector "script"
    assert_text "<Title>"
    assert_text "<script>alert(1)</script>"
  end

  def test_rejects_invalid_contracts_and_owned_attributes
    assert_raises(ArgumentError) { component(title: " ") }
    assert_raises(ArgumentError) { component(title: "Title", tone: :neutral) }
    assert_raises(ArgumentError) { component(title: "Title", announce: true) }
    assert_raises(ArgumentError) { component(title: "Title", heading_level: 1) }
    assert_raises(ArgumentError) { component(title: "Title", html_attributes: {aria: {live: "polite"}}) }
    assert_raises(ArgumentError) { component(title: "Title", html_attributes: {data: {tone: "danger"}}) }
  end

  private

  def component(**attributes)
    Imagusu::DesignSystem::AlertComponent.new(**attributes)
  end
end
