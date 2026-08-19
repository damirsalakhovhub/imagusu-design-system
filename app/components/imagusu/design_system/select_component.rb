# frozen_string_literal: true

module Imagusu
  module DesignSystem
    class SelectComponent < Internal::FormControlComponent
      HTML_ATTRIBUTES = %i[autofocus data form size].freeze
      OPTION_ATTRIBUTES = [:disabled].freeze

      def initialize(options:, selected: Internal::FormControlComponent::UNSET, prompt: nil, include_blank: Internal::FormControlComponent::UNSET, multiple: false, include_hidden: true, disabled_values: [], **attributes)
        super(**attributes)
        @options = normalize_options(options)
        @selected = selected
        @prompt = prompt
        @include_blank = include_blank
        @multiple = multiple
        @include_hidden = include_hidden
        @disabled_values = Array(disabled_values)

        validate_boolean!(:multiple, @multiple)
        validate_boolean!(:include_hidden, @include_hidden)
        validate_html_attributes!(HTML_ATTRIBUTES)
        raise ArgumentError, "prompt and include_blank are mutually exclusive" if @prompt && !@include_blank.equal?(Internal::FormControlComponent::UNSET) && @include_blank
        raise ArgumentError, "prompt is not supported for multiple selects" if @prompt && @multiple
      end

      def call
        attributes = control_attributes(css_class: "ids-select", allowed: HTML_ATTRIBUTES)
        attributes[:multiple] = @multiple
        control = form.select(method, @options, select_options, attributes)

        render_with_field(safe_join([external_hidden_field, control].compact))
      end

      private

      def select_options
        options = {prompt: @prompt, include_hidden: rails_hidden_field?, disabled: @disabled_values}
        options[:include_blank] = @include_blank unless @include_blank.equal?(Internal::FormControlComponent::UNSET)
        options[:selected] = @selected unless @selected.equal?(Internal::FormControlComponent::UNSET)
        options
      end

      def rails_hidden_field?
        @include_hidden && external_form_id.nil?
      end

      def external_hidden_field
        return unless @multiple && @include_hidden && external_form_id

        form.hidden_field(
          method,
          value: "",
          id: nil,
          multiple: true,
          form: external_form_id,
          autocomplete: "off",
          disabled: @disabled
        )
      end

      def external_form_id
        @html_attributes[:form]
      end

      def normalize_options(options)
        raise ArgumentError, "options must be an Array" unless options.is_a?(Array)

        options.map do |option|
          unless option.is_a?(Array) && [2, 3].include?(option.length)
            raise ArgumentError, "each option must contain label, value, and optional attributes"
          end

          label, value, attributes = option
          attributes ||= {}
          unless attributes.is_a?(Hash) && attributes.keys.all? { |key| key.respond_to?(:to_sym) }
            raise ArgumentError, "option attributes must be a Hash with string or symbol keys"
          end

          normalized_attributes = attributes.transform_keys(&:to_sym)
          unless (normalized_attributes.keys - OPTION_ATTRIBUTES).empty?
            raise ArgumentError, "option attributes only support disabled"
          end

          validate_boolean!(:disabled, normalized_attributes[:disabled]) if normalized_attributes.key?(:disabled)
          [label, value, normalized_attributes]
        end
      end
    end
  end
end
