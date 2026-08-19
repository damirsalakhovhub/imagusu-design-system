# frozen_string_literal: true

require "test_helper"

class Imagusu::DesignSystem::SelectComponentTest < ViewComponent::TestCase
  def test_renders_native_select_with_blank_option_and_selected_option
    render_inline(component(include_blank: "Choose a role", selected: "admin"))

    assert_selector "label[for='user_role']", text: "Role"
    assert_selector "select.ids-select#user_role[name='user[role]']"
    assert_selector "option[value='']", text: "Choose a role"
    assert_selector "option[value='admin'][selected]", text: "Administrator"
  end

  def test_renders_required_select_with_prompt
    render_inline(component(required: true, prompt: "Choose a role"))

    assert_selector "select[required] option[value='']", text: "Choose a role"
  end

  def test_supports_disabled_options_and_multiple_values
    render_inline(component(
      method: :roles,
      options: [["Member", "member"], ["Administrator", "admin", {disabled: true}]],
      selected: ["member"],
      multiple: true
    ))

    assert_selector "select[multiple] option[value='member'][selected]"
    assert_selector "option[value='admin'][disabled]"
  end

  def test_keeps_external_form_on_multiple_control_and_hidden_fallback
    render_inline(component(
      method: :roles,
      multiple: true,
      html_attributes: {form: "outside-form"}
    ))

    assert_selector "input[type='hidden'][name='user[roles][]'][form='outside-form']", visible: :all
    assert_selector "select[name='user[roles][]'][form='outside-form'][multiple]"
  end

  def test_connects_errors_and_supported_attributes
    render_inline(component(
      errors: ["must be selected"],
      html_attributes: {data: {controller: "select"}, aria: {details: "role-details"}}
    ))

    assert_selector "select[data-controller='select'][aria-details='role-details'][aria-invalid='true']"
    assert_selector "select[aria-describedby='user_role-error']"
  end

  def test_uses_form_builder_selected_value
    object = FormComponentTestModel.new(role: "admin")

    render_inline(component(form: form_builder(object)))

    assert_selector "option[value='admin'][selected]"
  end

  def test_escapes_option_content
    render_inline(component(options: [["<script>alert(1)</script>", %(' onclick='alert(1))]]))

    assert_no_selector "script"
    assert_selector "option", text: "<script>alert(1)</script>"
    assert_no_selector "option[onclick]"
  end

  def test_rejects_malformed_options_and_event_attributes
    assert_raises(ArgumentError) { component(options: ["admin"]) }
    assert_raises(ArgumentError) { component(html_attributes: {onchange: "alert(1)"}) }
    assert_raises(ArgumentError) { component(options: [["Admin", "admin", {"disabled" => "false"}]]) }
  end

  private

  def component(**attributes)
    defaults = {
      form: form_builder,
      method: :role,
      label: "Role",
      options: [["Member", "member"], ["Administrator", "admin"]]
    }

    Imagusu::DesignSystem::SelectComponent.new(**defaults.merge(attributes))
  end
end
