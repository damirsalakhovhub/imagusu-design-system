# frozen_string_literal: true

require "test_helper"

class Imagusu::DesignSystem::ErrorSummaryComponentTest < ViewComponent::TestCase
  def test_renders_focusable_alert_with_links_to_fields
    render_inline(component)

    assert_selector "#error-summary.ids-error-summary[tabindex='-1']"
    assert_selector "#error-summary > div[role='alert'][aria-labelledby='error-summary-title']"
    assert_selector "h2#error-summary-title", text: "There is a problem"
    assert_selector "a.ids-error-summary__link[href='#user_email']", text: "Enter a valid email"
    assert_selector "a[href='#user_role']", text: "Choose a role"
  end

  def test_supports_custom_id_description_and_safe_attributes
    render_inline(component(
      id: "profile-errors",
      description: "Check the highlighted fields.",
      classes: "form-errors",
      html_attributes: {data: {controller: "error-summary"}}
    ))

    assert_selector "#profile-errors.ids-error-summary.form-errors[data-controller='error-summary']"
    assert_selector "[role='alert'][aria-labelledby='profile-errors-title']"
    assert_selector ".ids-error-summary__description", text: "Check the highlighted fields."
  end

  def test_escapes_messages_and_description
    render_inline(component(
      title: "<Problem>",
      description: "<script>alert(1)</script>",
      errors: [{field_id: "user_email", message: "<img src=x onerror=alert(1)>"}]
    ))

    assert_no_selector "script, img"
    assert_text "<Problem>"
    assert_text "<script>alert(1)</script>"
    assert_text "<img src=x"
  end

  def test_rejects_invalid_entries_ids_and_owned_aria
    assert_raises(ArgumentError) { component(errors: []) }
    assert_raises(ArgumentError) { component(errors: ["Email is invalid"]) }
    assert_raises(ArgumentError) { component(errors: [{field_id: "user email", message: "Invalid"}]) }
    assert_raises(ArgumentError) { component(errors: [{field_id: "#user_email", message: "Invalid"}]) }
    assert_raises(ArgumentError) { component(errors: [{field_id: "email", message: " "}]) }
    assert_raises(ArgumentError) { component(errors: [{field_id: "email", message: "Invalid", html: "unsafe"}]) }
    assert_raises(ArgumentError) { component(id: "error summary") }
    assert_raises(ArgumentError) { component(html_attributes: {aria: {labelledby: "other"}}) }
  end

  def test_escapes_fragment_ids
    result = render_inline(component(errors: [{field_id: %(email"onclick="alert(1)), message: "Invalid"}]))

    assert_no_selector "a[onclick]"
    assert_equal %(#email"onclick="alert(1)), result.at_css("a")["href"]
  end

  private

  def component(**attributes)
    defaults = {
      title: "There is a problem",
      errors: [
        {field_id: "user_email", message: "Enter a valid email"},
        {field_id: "user_role", message: "Choose a role"}
      ]
    }

    Imagusu::DesignSystem::ErrorSummaryComponent.new(**defaults.merge(attributes))
  end
end
