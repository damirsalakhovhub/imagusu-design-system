# frozen_string_literal: true

module Imagusu
  module DesignSystem
    class CheckboxComponent < Internal::FormControlComponent
      HTML_ATTRIBUTES = %i[autofocus data form].freeze

      def initialize(checked: Internal::FormControlComponent::UNSET, checked_value: "1", unchecked_value: "0", include_hidden: true, **attributes)
        super(**attributes)
        @checked = checked
        @checked_value = checked_value
        @unchecked_value = unchecked_value
        @include_hidden = include_hidden

        validate_boolean!(:checked, @checked) unless @checked.equal?(Internal::FormControlComponent::UNSET)
        validate_boolean!(:include_hidden, @include_hidden)
        validate_html_attributes!(HTML_ATTRIBUTES)
        raise ArgumentError, "checked and unchecked values must differ" if @checked_value.to_s == @unchecked_value.to_s
      end

      def call
        attributes = control_attributes(css_class: "ids-checkbox__control", allowed: HTML_ATTRIBUTES)
        attributes[:include_hidden] = @include_hidden
        attributes[:checked] = @checked unless @checked.equal?(Internal::FormControlComponent::UNSET)

        control = form.checkbox(method, attributes, @checked_value, @unchecked_value)
        render checkbox_field.with_content(control)
      end

      private

      def checkbox_field
        CheckboxFieldComponent.new(
          control_id: id,
          label: label,
          label_suffix: @label_suffix,
          hint: hint,
          errors: errors,
          required: @required,
          disabled: @disabled
        )
      end
    end
  end
end
