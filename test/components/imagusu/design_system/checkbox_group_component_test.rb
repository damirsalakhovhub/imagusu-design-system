# frozen_string_literal: true

require "test_helper"

class Imagusu::DesignSystem::CheckboxGroupComponentTest < ViewComponent::TestCase
  def test_renders_native_fieldset_legend_and_checkboxes
    render_inline(component)

    assert_selector "fieldset.ids-checkbox-group#user_interests"
    assert_selector "legend.ids-checkbox-group__legend", text: "Interests"
    assert_selector "input[type='hidden'][name='user[interests][]'][value='']", visible: :all
    assert_selector "input#user_interests_music[type='checkbox'][name='user[interests][]'][value='music']"
    assert_selector "label[for='user_interests_music']", text: "Music"
  end

  def test_supports_selected_and_disabled_values
    render_inline(component(selected: ["music"], disabled_values: ["sports"]))

    assert_selector "input[value='music'][checked]"
    assert_selector "input[value='sports'][disabled]"
  end

  def test_uses_form_builder_values
    object = FormComponentTestModel.new(interests: ["sports"])
    render_inline(component(form: form_builder(object)))

    assert_selector "input[value='sports'][checked]"
  end

  def test_connects_group_hint_and_error_only_to_fieldset
    render_inline(component(hint: "Choose any", errors: ["Choose at least one"]))

    assert_selector "fieldset[aria-describedby='user_interests-hint user_interests-error'][aria-invalid='true']"
    assert_selector "input[type='checkbox']:not([aria-describedby]):not([aria-invalid])", count: 2
  end

  def test_keeps_external_form_on_controls_and_hidden_fallback
    render_inline(component(html_attributes: {form: "preferences-form"}))

    assert_selector "input[type='hidden'][name='user[interests][]'][form='preferences-form']", visible: :all
    assert_selector "input[type='checkbox'][form='preferences-form']", count: 2
  end

  def test_disabled_group_does_not_submit_hidden_fallback
    render_inline(component(disabled: true))

    assert_selector "fieldset[disabled]"
    assert_no_selector "input[type='hidden']", visible: :all
  end

  def test_rejects_ambiguous_or_invalid_contracts
    assert_raises(ArgumentError) { component(required: true) }
    assert_raises(ArgumentError) { component(selected: "music") }
    assert_raises(ArgumentError) { component(include_hidden: "false") }
    assert_raises(ArgumentError) { component(options: []) }
    assert_raises(ArgumentError) { component(options: [["", "music"]]) }
    assert_raises(ArgumentError) { component(options: [["Music", ""]]) }
    assert_raises(ArgumentError) { component(options: [["Space", "a b"], ["Underscore", "a_b"]]) }
    assert_raises(ArgumentError) { component(html_attributes: {data: {state: "valid"}}) }
  end

  def test_escapes_option_labels
    render_inline(component(options: [["<script>alert(1)</script>", %(' onclick='alert(1))]]))

    assert_no_selector "script"
    assert_no_selector "input[onclick]"
    assert_selector "label", text: "<script>alert(1)</script>"
  end

  private

  def component(**attributes)
    defaults = {
      form: form_builder,
      method: :interests,
      label: "Interests",
      options: [["Music", "music"], ["Sports", "sports"]]
    }

    Imagusu::DesignSystem::CheckboxGroupComponent.new(**defaults.merge(attributes))
  end
end
