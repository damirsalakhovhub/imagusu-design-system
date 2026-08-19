# frozen_string_literal: true

require "test_helper"

class Imagusu::DesignSystem::FieldComponentTest < ViewComponent::TestCase
  def test_renders_label_and_control_content
    render_inline(component) { %(<input id="user_email">).html_safe }

    assert_selector ".ids-field[data-state='default']"
    assert_selector "label.ids-field__label[for='user_email']", text: "Email"
    assert_selector "input#user_email", count: 1
  end

  def test_connects_hint_and_errors
    field = component(hint: "Used for receipts", errors: ["is invalid", "is already used"])

    assert_equal "user_email-hint user_email-error", field.described_by
    assert_equal({
      id: "user_email",
      required: false,
      disabled: false,
      aria: {describedby: "user_email-hint user_email-error", invalid: "true"}
    }, field.control_attributes)

    render_inline(field) { %(<input id="user_email">).html_safe }

    assert_selector ".ids-field[data-state~='invalid']"
    assert_selector "#user_email-hint.ids-field__hint", text: "Used for receipts"
    assert_selector "#user_email-error.ids-field__error", text: "is invalid. is already used"
  end

  def test_exposes_required_and_disabled_states
    render_inline(component(required: true, disabled: true, label_suffix: "(required)")) { "Control" }

    assert_selector ".ids-field[data-state~='required'][data-state~='disabled']"
    assert_selector "label .ids-field__label-suffix", text: "(required)"
  end

  def test_escapes_label_hint_and_errors
    render_inline(component(label: "<Label>", hint: "<Hint>", errors: ["<Error>"])) { "Control" }

    assert_text "<Label>"
    assert_text "<Hint>"
    assert_text "<Error>"
    assert_no_selector "label label, script"
  end

  def test_rejects_empty_accessible_label
    assert_raises(ArgumentError) { component(label: " ") }
  end

  def test_rejects_empty_or_whitespace_control_ids
    ["", " ", "user email", "user\temail", "user\nemail"].each do |control_id|
      assert_raises(ArgumentError) do
        Imagusu::DesignSystem::FieldComponent.new(control_id: control_id, label: "Email")
      end
    end
  end

  private

  def component(**attributes)
    Imagusu::DesignSystem::FieldComponent.new(
      control_id: "user_email",
      label: "Email",
      **attributes
    )
  end
end
