# frozen_string_literal: true

require "test_helper"

class Imagusu::DesignSystem::CheckboxComponentTest < ViewComponent::TestCase
  def test_renders_checkbox_with_rails_style_hidden_value
    render_inline(component)

    assert_selector "input[type='hidden'][name='user[terms]'][value='0']", visible: :all
    assert_selector "input.ids-checkbox__control#user_terms[type='checkbox'][name='user[terms]'][value='1']"
    assert_selector "label.ids-checkbox__label[for='user_terms']", text: "Accept terms"
  end

  def test_renders_checked_required_and_disabled_states
    render_inline(component(checked: true, required: true, disabled: true))

    assert_selector ".ids-field[data-state~='required'][data-state~='disabled']"
    assert_selector "input[type='hidden'][disabled]", visible: :all
    assert_selector "input[type='checkbox'][checked][required][disabled]"
  end

  def test_connects_hint_and_errors
    render_inline(component(hint: "Required to continue", errors: ["must be accepted"]))

    assert_selector "input[type='checkbox'][aria-describedby='user_terms-hint user_terms-error'][aria-invalid='true']"
    assert_selector "#user_terms-hint", text: "Required to continue"
    assert_selector "#user_terms-error", text: "must be accepted"
  end

  def test_can_omit_hidden_value_and_add_safe_attributes
    render_inline(component(
      include_hidden: false,
      classes: "legal-checkbox",
      html_attributes: {data: {action: "terms#toggle"}}
    ))

    assert_no_selector "input[type='hidden']", visible: :all
    assert_selector "input.ids-checkbox__control.legal-checkbox[data-action='terms#toggle']"
  end

  def test_uses_form_builder_checked_value
    object = FormComponentTestModel.new(terms: true)
    render_inline(component(form: form_builder(object)))

    assert_selector "input[type='checkbox'][checked]"
  end

  def test_rejects_non_boolean_state_and_event_attributes
    assert_raises(ArgumentError) { component(checked: "true") }
    assert_raises(ArgumentError) { component(include_hidden: "false") }
    assert_raises(ArgumentError) { component(html_attributes: {onclick: "alert(1)"}) }
  end

  private

  def component(**attributes)
    defaults = {
      form: form_builder,
      method: :terms,
      label: "Accept terms"
    }

    Imagusu::DesignSystem::CheckboxComponent.new(**defaults.merge(attributes))
  end
end
