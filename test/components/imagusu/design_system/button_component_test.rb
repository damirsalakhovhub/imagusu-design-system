# frozen_string_literal: true

require "test_helper"

class Imagusu::DesignSystem::ButtonComponentTest < ViewComponent::TestCase
  def test_renders_button_content_and_safe_defaults
    render_inline(component) { "Save" }

    assert_selector "button[type='button']:not([disabled])", text: "Save", count: 1
  end

  def test_supports_submit_and_disabled_states
    render_inline(component(type: :submit, disabled: true)) { "Create" }

    assert_selector "button[type='submit'][disabled]", text: "Create", count: 1
  end

  def test_passes_supported_html_attributes
    render_inline(component(html_attributes: {
      id: "save",
      form: "profile",
      data: {action: "editor#save"},
      aria: {label: "Save profile"}
    })) { "Save" }

    assert_selector "button#save[form='profile'][data-action='editor#save'][aria-label='Save profile']"
  end

  def test_escapes_content_and_attributes
    result = render_inline(component(html_attributes: {title: %(<script>alert("x")</script>)})) do
      %(<img src=x onerror=alert("x")>)
    end

    assert_empty result.css("script, img")
    assert_equal %(<script>alert("x")</script>), result.at_css("button")["title"]
    assert_includes result.text, "<img src=x"
  end

  def test_rejects_unknown_button_type
    error = assert_raises(ArgumentError) { component(type: :link) }

    assert_match "type must be one of", error.message
  end

  def test_rejects_non_boolean_disabled_state
    error = assert_raises(ArgumentError) { component(disabled: "false") }

    assert_equal "disabled must be true or false", error.message
  end

  def test_rejects_unknown_html_attributes
    error = assert_raises(ArgumentError) { component(html_attributes: {onclick: "alert(1)"}) }

    assert_match "unsupported HTML attributes: onclick", error.message
  end

  def test_rejects_non_hash_html_attributes
    error = assert_raises(ArgumentError) { component(html_attributes: "id=save") }

    assert_equal "html_attributes must be a Hash", error.message
  end

  private

  def component(**attributes)
    Imagusu::DesignSystem::ButtonComponent.new(**attributes)
  end
end
