# frozen_string_literal: true

require "test_helper"

class Imagusu::DesignSystem::TextFieldComponentTest < ViewComponent::TestCase
  def test_renders_native_text_field
    render_inline(component(value: "ada@example.com"))

    assert_selector "label[for='user_email']", text: "Email"
    assert_selector "input.ids-input#user_email[name='user[email]'][type='text'][value='ada@example.com']"
  end

  def test_connects_hint_and_errors_to_input
    render_inline(component(hint: "Work address", errors: ["is invalid"], required: true))

    assert_selector "input[required][aria-describedby='user_email-hint user_email-error'][aria-invalid='true']"
    assert_selector "#user_email-hint", text: "Work address"
    assert_selector "#user_email-error", text: "is invalid"
  end

  def test_supports_safe_types_attributes_and_classes
    render_inline(component(
      type: :email,
      classes: "account-email",
      html_attributes: {
        autocomplete: "email",
        placeholder: "name@example.com",
        data: {controller: "email"},
        aria: {details: "email-details"}
      }
    ))

    assert_selector "input.ids-input.account-email[type='email'][autocomplete='email'][placeholder='name@example.com']"
    assert_selector "input[data-controller='email'][aria-details='email-details']"
  end

  def test_preserves_external_descriptions
    render_inline(component(hint: "Hint", html_attributes: {aria: {describedby: ["external", "user_email-hint"]}}))

    assert_selector "input[aria-describedby='external user_email-hint']"
  end

  def test_uses_form_builder_binding_and_existing_errors
    object = FormComponentTestModel.new(email: "bound@example.com")
    object.errors.add(:email, "is invalid")

    render_inline(component(form: form_builder(object)))

    assert_selector "input[value='bound@example.com'][aria-invalid='true'][aria-describedby='user_email-error']"
    assert_selector "#user_email-error", text: "Email is invalid"
  end

  def test_preserves_nested_builder_names_and_ids
    nested_form = form_builder(object_name: "account[users_attributes][0]")

    render_inline(component(form: nested_form))

    assert_selector "label[for='account_users_attributes_0_email']"
    assert_selector "input#account_users_attributes_0_email[name='account[users_attributes][0][email]']"
  end

  def test_does_not_echo_password_values
    render_inline(component(type: :password, value: "secret"))

    assert_selector "input[type='password']:not([value])"
  end

  def test_rejects_unknown_type_and_attributes
    assert_raises(ArgumentError) { component(type: :checkbox) }
    assert_raises(ArgumentError) { component(html_attributes: {onclick: "alert(1)"}) }

    %i[checked disabled hidden invalid label labelledby readonly required selected].each do |attribute|
      assert_raises(ArgumentError) { component(html_attributes: {aria: {attribute => true}}) }
    end
  end

  def test_rejects_invalid_builder_label_and_errors_contracts
    assert_raises(ArgumentError) { component(form: nil) }
    assert_raises(ArgumentError) { component(label: " ") }
    assert_raises(ArgumentError) { component(errors: true) }
  end

  private

  def component(**attributes)
    defaults = {
      form: form_builder,
      method: :email,
      label: "Email"
    }

    Imagusu::DesignSystem::TextFieldComponent.new(**defaults.merge(attributes))
  end
end
