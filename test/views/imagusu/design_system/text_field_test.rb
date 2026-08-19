# frozen_string_literal: true

require "test_helper"

class Imagusu::DesignSystem::TextFieldViewTest < ActionView::TestCase
  def test_uses_the_native_form_builder_binding
    object = FormComponentTestModel.new(email: "ada@example.com")

    render_text_field(form: form_builder(object), method: :email, label: "Email")

    assert_select "label.ids-field__label[for='user_email']", text: "Email"
    assert_select "input.ids-input#user_email[name='user[email]'][type='text'][value='ada@example.com']"
    assert_select "input[aria-invalid]", count: 0
  end

  def test_preserves_nested_names_and_ids
    render_text_field(
      form: form_builder(object_name: "account[users_attributes][0]"),
      method: :email,
      label: "Email"
    )

    assert_select "label[for='account_users_attributes_0_email']"
    assert_select "input#account_users_attributes_0_email[name='account[users_attributes][0][email]']"
  end

  def test_connects_hint_errors_and_external_descriptions
    render_text_field(
      form: form_builder,
      method: :email,
      label: "Email",
      hint: "Work address",
      errors: ["is invalid"],
      required: true,
      html_attributes: {aria: {describedby: ["external", "user_email-hint"]}}
    )

    assert_select ".ids-field[data-state~='invalid'][data-state~='required']"
    assert_select "input[required][aria-invalid='true'][aria-describedby='external user_email-hint user_email-error']"
    assert_select "#user_email-hint", text: "Work address", count: 1
    assert_select "#user_email-error", text: "is invalid", count: 1
  end

  def test_uses_existing_model_errors_without_running_validation
    object = FormComponentTestModel.new(email: "bound@example.com")
    object.errors.add(:email, "is invalid")

    render_text_field(form: form_builder(object), method: :email, label: "Email")

    assert_select "input[value='bound@example.com'][aria-invalid='true'][aria-describedby='user_email-error']"
    assert_select "#user_email-error", text: "Email is invalid"
    assert_select ".field_with_errors", count: 1 do
      assert_select "input", count: 1
      assert_select "label", count: 0
    end
  end

  def test_supports_safe_types_and_attributes
    render_text_field(
      form: form_builder,
      method: :email,
      label: "Email",
      type: :email,
      disabled: true,
      html_attributes: {
        autocomplete: "email",
        placeholder: "name@example.com",
        data: {controller: "email"},
        aria: {details: "email-details"}
      }
    )

    assert_select ".ids-field[data-state~='disabled']"
    assert_select "input.ids-input[type='email'][disabled][autocomplete='email'][placeholder='name@example.com']"
    assert_select "input[data-controller='email'][aria-details='email-details']"
  end

  def test_password_never_echoes_the_bound_value
    object = FormComponentTestModel.new(email: "secret")

    render_text_field(form: form_builder(object), method: :email, label: "Password", type: :password)

    assert_select "input[type='password']:not([value])"
  end

  def test_escapes_visible_copy
    render_text_field(
      form: form_builder,
      method: :email,
      label: "<b>Email</b>",
      hint: "<script>bad()</script>",
      errors: ['" invalid']
    )

    assert_includes rendered, "&lt;b&gt;Email&lt;/b&gt;"
    assert_includes rendered, "&lt;script&gt;bad()&lt;/script&gt;"
    assert_select "b, script", count: 0
  end

  def test_rejects_invalid_contracts_and_owned_attributes
    assert_raises(ActionView::Template::Error) { render_text_field(form: nil, method: :email, label: "Email") }
    assert_raises(ActionView::Template::Error) { render_text_field(form: form_builder, method: :email, label: " ") }
    assert_raises(ActionView::Template::Error) { render_text_field(form: form_builder, method: :email, label: "Email", type: :checkbox) }
    assert_raises(ActionView::Template::Error) { render_text_field(form: form_builder, method: :email, label: "Email", required: nil) }
    assert_raises(ActionView::Template::Error) do
      render_text_field(form: form_builder, method: :email, label: "Email", html_attributes: {id: "override"})
    end
    assert_raises(ActionView::Template::Error) do
      render_text_field(form: form_builder, method: :email, label: "Email", html_attributes: {aria: {label: "Different"}})
    end
    assert_raises(ActionView::Template::Error) do
      render_text_field(form: form_builder, method: :email, label: "Email", errors: true)
    end
  end

  def test_strict_locals_reject_missing_and_unknown_input
    assert_raises(ActionView::Template::Error) { render partial: PARTIAL, locals: {} }
    assert_raises(ActionView::Template::Error) do
      render partial: PARTIAL, locals: {form: form_builder, method: :email, label: "Email", unknown: true}
    end
  end

  private

  PARTIAL = "imagusu/design_system/text_field"

  def form_builder(object = FormComponentTestModel.new, object_name: :user, **options)
    ActionView::Helpers::FormBuilder.new(object_name, object, controller.view_context, options)
  end

  def render_text_field(**locals)
    render partial: PARTIAL, locals: locals
  end
end
