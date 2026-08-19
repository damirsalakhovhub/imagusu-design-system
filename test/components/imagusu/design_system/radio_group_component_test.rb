# frozen_string_literal: true

require "test_helper"

class Imagusu::DesignSystem::RadioGroupComponentTest < ViewComponent::TestCase
  def test_renders_native_fieldset_legend_and_radios
    render_inline(component)

    assert_selector "fieldset.ids-radio-group#notification_frequency"
    assert_selector "legend.ids-radio-group__legend", text: "Notifications"
    assert_selector "input[type='hidden'][name='notification[frequency]'][value='']", visible: :all
    assert_selector "input#notification_frequency_daily[type='radio'][name='notification[frequency]'][value='daily']"
    assert_selector "label[for='notification_frequency_daily']", text: "Daily"
  end

  def test_selects_value_and_supports_disabled_option
    render_inline(component(
      selected: "weekly",
      options: [["Daily", "daily"], ["Weekly", "weekly"], ["Never", "never"]],
      disabled_values: ["never"]
    ))

    assert_selector "input[value='weekly'][checked]"
    assert_selector "input[value='never'][disabled]"
  end

  def test_connects_group_hint_and_errors
    render_inline(component(hint: "Choose one", errors: ["must be selected"], required: true, label_suffix: "(required)"))

    assert_selector "fieldset[data-state~='invalid'][data-state~='required'][aria-describedby='notification_frequency-hint notification_frequency-error'][aria-invalid='true']"
    assert_selector "legend .ids-field__label-suffix", text: "(required)"
    assert_selector "input[type='radio'][required]:not([aria-describedby]):not([aria-invalid])", count: 2
  end

  def test_disables_entire_group_and_hidden_value
    render_inline(component(disabled: true))

    assert_selector "fieldset[disabled]"
    assert_no_selector "input[type='hidden']", visible: :all
  end

  def test_uses_form_builder_checked_value
    object = FormComponentTestModel.new(frequency: "weekly")

    render_inline(component(form: form_builder(object, object_name: :notification)))

    assert_selector "input[value='weekly'][checked]"
  end

  def test_keeps_external_form_on_radios_and_hidden_fallback
    render_inline(component(html_attributes: {form: "outside-form"}))

    assert_selector "input[type='hidden'][name='notification[frequency]'][form='outside-form']", visible: :all
    assert_selector "input[type='radio'][form='outside-form']", count: 2
  end

  def test_rejects_duplicate_values_and_escapes_labels
    assert_raises(ArgumentError) { component(options: [["Daily", 1], ["Weekly", "1"]]) }
    assert_raises(ArgumentError) { component(options: [["Space", "a b"], ["Underscore", "a_b"]]) }
    assert_raises(ArgumentError) { component(options: [["", "daily"]]) }
    assert_raises(ArgumentError) { component(options: [["Daily", ""]]) }

    render_inline(component(options: [["<script>alert(1)</script>", "daily"]]))
    assert_no_selector "script"
    assert_selector "label", text: "<script>alert(1)</script>"
  end

  def test_rejects_malformed_options_and_unknown_option_attributes
    assert_raises(ArgumentError) { component(options: ["daily"]) }
    assert_raises(ArgumentError) { component(options: [["Daily", "daily", {onclick: "alert(1)"}]]) }
  end

  private

  def component(**attributes)
    defaults = {
      form: form_builder(object_name: :notification),
      method: :frequency,
      label: "Notifications",
      options: [["Daily", "daily"], ["Weekly", "weekly"]]
    }

    Imagusu::DesignSystem::RadioGroupComponent.new(**defaults.merge(attributes))
  end
end
