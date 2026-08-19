# frozen_string_literal: true

module Imagusu
  module DesignSystem
    module Internal
      class FormControlComponent < Imagusu::DesignSystem::BaseComponent
        BOOLEAN_VALUES = [true, false].freeze
        UNSET = Object.new.freeze

        attr_reader :form, :method, :id, :label, :hint, :errors

        def initialize(form:, method:, label:, label_suffix: nil, hint: nil, errors: :auto, required: false, disabled: false, classes: nil, html_attributes: {})
          @form = form
          @method = method.respond_to?(:to_sym) ? method.to_sym : method
          @id = form.field_id(@method).to_s if valid_form_builder?
          @label = label.to_s
          @label_suffix = label_suffix.to_s unless label_suffix.nil? || label_suffix.to_s.empty?
          @hint = hint.to_s unless hint.nil? || hint.to_s.empty?
          @errors = normalize_errors(errors)
          @required = required
          @disabled = disabled
          @classes = classes
          @html_attributes = normalize_html_attributes(html_attributes)

          validate_required_values!
          validate_aria_attributes!
        end

        private

        def render_with_field(control)
          render field.with_content(control)
        end

        def field
          @field ||= FieldComponent.new(
            control_id: id,
            label: label,
            label_suffix: @label_suffix,
            hint: hint,
            errors: errors,
            required: @required,
            disabled: @disabled
          )
        end

        def control_attributes(css_class:, allowed:)
          validate_html_attributes!(allowed)

          attributes = @html_attributes.except(:aria)
          attributes.merge(
            id: id,
            required: @required,
            disabled: @disabled,
            class: class_names(css_class, @classes),
            aria: merged_aria_attributes
          )
        end

        def merged_aria_attributes
          aria = normalized_aria_attributes
          external_descriptions = Array(aria.delete(:describedby)).flat_map { |value| value.to_s.split }
          descriptions = (external_descriptions + field.described_by.to_s.split).uniq

          aria[:describedby] = descriptions.join(" ") unless descriptions.empty?
          aria[:invalid] = "true" if errors.any?
          aria
        end

        def normalize_html_attributes(attributes)
          raise ArgumentError, "html_attributes must be a Hash" unless attributes.is_a?(Hash)

          attributes.to_h do |key, value|
            raise ArgumentError, "HTML attribute keys must be strings or symbols" unless key.respond_to?(:to_sym)

            [key.to_sym, value]
          end
        end

        def normalized_aria_attributes
          aria = @html_attributes.fetch(:aria, {})
          raise ArgumentError, "aria must be a Hash" unless aria.is_a?(Hash)

          aria.to_h do |key, value|
            raise ArgumentError, "ARIA attribute keys must be strings or symbols" unless key.respond_to?(:to_sym)

            [key.to_sym, value]
          end
        end

        def validate_html_attributes!(allowed)
          unsupported = @html_attributes.keys - (allowed + [:aria])
          return if unsupported.empty?

          raise ArgumentError, "unsupported HTML attributes: #{unsupported.join(", ")}"
        end

        def validate_required_values!
          raise ArgumentError, "form must be a Rails FormBuilder" unless valid_form_builder?
          raise ArgumentError, "method must not be empty" if @method.nil? || @method.to_s.strip.empty?
          raise ArgumentError, "id must not be empty" if id.empty?
          raise ArgumentError, "label must not be empty" if label.strip.empty?

          validate_boolean!(:required, @required)
          validate_boolean!(:disabled, @disabled)
        end

        def valid_form_builder?
          form.respond_to?(:field_id) && form.respond_to?(:field_name)
        end

        def normalize_errors(value)
          messages = if value == :auto
            if form.respond_to?(:object) && form.object.respond_to?(:errors)
              form.object.errors.full_messages_for(@method)
            else
              []
            end
          elsif value.nil? || value == false
            []
          elsif value.is_a?(String) || value.is_a?(Array)
            Array(value)
          else
            raise ArgumentError, "errors must be :auto, false, nil, a String, or an Array"
          end

          messages.compact.map(&:to_s).reject(&:empty?)
        end

        def validate_aria_attributes!
          aria = normalized_aria_attributes
          owned = aria.keys & %i[checked disabled hidden invalid label labelledby readonly required selected]
          return if owned.empty?

          raise ArgumentError, "component owns ARIA attributes: #{owned.join(", ")}"
        end

        def validate_boolean!(name, value)
          return if BOOLEAN_VALUES.include?(value)

          raise ArgumentError, "#{name} must be true or false"
        end

        def state_tokens
          states = []
          states << "invalid" if errors.any?
          states << "required" if @required
          states << "disabled" if @disabled
          states.empty? ? "default" : states.join(" ")
        end

        def hint_id
          "#{id}-hint" if hint
        end

        def error_id
          "#{id}-error" if errors.any?
        end

        def described_by
          [hint_id, error_id].compact.join(" ").presence
        end

        def error_text
          errors.join(". ")
        end
      end
    end
  end
end
