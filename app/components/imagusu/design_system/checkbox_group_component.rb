# frozen_string_literal: true

module Imagusu
  module DesignSystem
    class CheckboxGroupComponent < Internal::FormControlComponent
      HTML_ATTRIBUTES = %i[data form].freeze

      def initialize(options:, selected: Internal::FormControlComponent::UNSET, include_hidden: true, disabled_values: [], required: false, **attributes)
        raise ArgumentError, "required must be true or false" unless [true, false].include?(required)
        raise ArgumentError, "CheckboxGroup does not support group-level required" if required

        super(required: false, **attributes)
        @options = normalize_options(options)
        @selected = selected
        @include_hidden = include_hidden
        @disabled_values = Array(disabled_values)

        unless @selected.equal?(Internal::FormControlComponent::UNSET) || @selected.is_a?(Array)
          raise ArgumentError, "selected must be an Array"
        end

        validate_boolean!(:include_hidden, @include_hidden)
        validate_html_attributes!(HTML_ATTRIBUTES)
        data_with_state(data: @html_attributes.fetch(:data, {}))
        validate_unique_ids!
      end

      private

      def fieldset_attributes
        attributes = control_attributes(css_class: "ids-checkbox-group", allowed: HTML_ATTRIBUTES).except(:required)
        attributes.merge(data: data_with_state(attributes))
      end

      def checkboxes
        options = {include_hidden: rails_hidden_field?, disabled: @disabled_values}
        options[:checked] = @selected unless @selected.equal?(Internal::FormControlComponent::UNSET)
        html_options = {
          disabled: @disabled,
          class: "ids-checkbox-group__control",
          form: external_form_id
        }.compact

        controls = form.collection_check_boxes(method, @options, :last, :first, options, html_options) do |builder|
          tag.div(class: "ids-checkbox-group__option") do
            safe_join([
              builder.checkbox,
              builder.label(class: "ids-checkbox-group__label")
            ])
          end
        end

        safe_join([external_hidden_field, controls].compact)
      end

      def rails_hidden_field?
        @include_hidden && !@disabled && external_form_id.nil?
      end

      def external_hidden_field
        return unless @include_hidden && !@disabled && external_form_id

        form.hidden_field(
          method,
          value: "",
          id: nil,
          multiple: true,
          form: external_form_id,
          autocomplete: "off"
        )
      end

      def external_form_id
        @html_attributes[:form]
      end

      def normalize_options(options)
        raise ArgumentError, "options must be a non-empty Array" unless options.is_a?(Array) && options.any?

        options.map do |option|
          unless option.is_a?(Array) && option.length == 2
            raise ArgumentError, "each option must contain label and value"
          end

          option_label, value = option
          raise ArgumentError, "checkbox option labels must not be empty" if option_label.to_s.strip.empty?
          raise ArgumentError, "checkbox option values must not be empty" if value.to_s.empty?

          [option_label, value]
        end
      end

      def validate_unique_ids!
        ids = @options.map { |_, value| "#{id}_#{sanitized_collection_value(value)}" }
        return if ids.uniq.length == ids.length

        raise ArgumentError, "checkbox option values must produce unique HTML IDs"
      end
    end
  end
end
