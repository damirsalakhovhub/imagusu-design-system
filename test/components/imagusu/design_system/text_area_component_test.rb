# frozen_string_literal: true

require "test_helper"

class Imagusu::DesignSystem::TextAreaComponentTest < ViewComponent::TestCase
  def test_renders_native_textarea
    render_inline(component(value: "A short biography"))

    assert_selector "label[for='user_bio']", text: "Biography"
    assert_selector "textarea.ids-textarea#user_bio[name='user[bio]']", text: "A short biography"
  end

  def test_supports_attributes_and_error_description
    render_inline(component(
      errors: ["is too long"],
      html_attributes: {rows: 6, maxlength: 500, placeholder: "About you"}
    ))

    assert_selector "textarea[rows='6'][maxlength='500'][placeholder='About you'][aria-invalid='true']"
    assert_selector "textarea[aria-describedby='user_bio-error']"
  end

  def test_escapes_value_and_rejects_event_attributes
    render_inline(component(value: "</textarea><script>alert(1)</script>"))

    assert_no_selector "script"
    assert_text "</textarea><script>alert(1)</script>"
    assert_raises(ArgumentError) { component(html_attributes: {oninput: "alert(1)"}) }
  end

  private

  def component(**attributes)
    Imagusu::DesignSystem::TextAreaComponent.new(
      form: form_builder,
      method: :bio,
      label: "Biography",
      **attributes
    )
  end
end
