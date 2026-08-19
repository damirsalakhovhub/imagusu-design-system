# frozen_string_literal: true

require "test_helper"

class Imagusu::DesignSystem::ButtonViewTest < ActionView::TestCase
  def test_renders_a_native_button
    render_button(content: "Save")

    assert_select "button.ids-button[type='button']", text: "Save"
    assert_select "button[disabled]", count: 0
  end

  def test_supports_native_state_and_safe_attributes
    render_button(
      content: "Save",
      type: :submit,
      disabled: true,
      html_attributes: {
        id: "save-profile",
        name: "commit",
        value: "save",
        form: "profile-form",
        data: {action: "profile#save"},
        aria: {describedby: "save-help", details: "save-details"}
      }
    )

    assert_select "button.ids-button#save-profile[type='submit'][disabled][form='profile-form'][name='commit'][value='save']"
    assert_select "button[data-action='profile#save'][aria-describedby='save-help'][aria-details='save-details']"
  end

  def test_escapes_content_and_attributes
    render_button(content: "<script>bad()</script>", html_attributes: {value: '" unsafe'})

    assert_includes rendered, "&lt;script&gt;bad()&lt;/script&gt;"
    assert_select "script", count: 0
    assert_select 'button[value="\" unsafe"]'
  end

  def test_renders_consumer_owned_unicode_content
    render_button(content: "Сохранить")

    assert_select "button.ids-button", text: "Сохранить"
  end

  def test_rejects_invalid_or_owned_input
    assert_raises(ActionView::Template::Error) { render_button(content: " ") }
    assert_raises(ActionView::Template::Error) { render_button(content: "Save", type: :link) }
    assert_raises(ActionView::Template::Error) { render_button(content: "Reset", type: :reset) }
    assert_raises(ActionView::Template::Error) { render_button(content: "Save", disabled: nil) }
    assert_raises(ActionView::Template::Error) { render_button(content: "Save", html_attributes: {class: "override"}) }
    assert_raises(ActionView::Template::Error) { render_button(content: "Save", html_attributes: {title: "Extra"}) }
    assert_raises(ActionView::Template::Error) { render_button(content: "Save", html_attributes: {autofocus: true}) }
    assert_raises(ActionView::Template::Error) { render_button(content: "Save", html_attributes: {aria: {label: "Different"}}) }
    assert_raises(ActionView::Template::Error) { render_button(content: "Save", html_attributes: {aria: {labelledby: "different"}}) }
    assert_raises(ActionView::Template::Error) { render_button(content: "Save", html_attributes: {aria: {hidden: true}}) }
    assert_raises(ActionView::Template::Error) { render_button(content: "Save", html_attributes: {aria: {disabled: true}}) }
    assert_raises(ActionView::Template::Error) { render_button(content: "Save", html_attributes: {aria: {pressed: false}}) }
    assert_raises(ActionView::Template::Error) { render_button(content: "Save", html_attributes: {aria: {expanded: false}}) }
    assert_raises(ActionView::Template::Error) { render_button(content: "Save", html_attributes: {aria: {haspopup: "menu"}}) }
    assert_raises(ActionView::Template::Error) { render_button(content: "Save", html_attributes: {aria: {busy: true}}) }
    assert_raises(ActionView::Template::Error) { render_button(content: "Save", html_attributes: {aria: {live: "polite"}}) }
    assert_raises(ActionView::Template::Error) { render_button(content: "Save", html_attributes: {aria: {controls: "menu"}}) }
    assert_raises(ActionView::Template::Error) { render_button(content: '<svg aria-hidden="true"></svg>'.html_safe) }
  end

  def test_strict_locals_reject_missing_and_unknown_input
    assert_raises(ActionView::Template::Error) { render partial: PARTIAL, locals: {} }
    assert_raises(ActionView::Template::Error) do
      render partial: PARTIAL, locals: {content: "Save", unknown: true}
    end
  end

  private

  PARTIAL = "imagusu/design_system/button"

  def render_button(**locals)
    render partial: PARTIAL, locals: locals
  end
end
