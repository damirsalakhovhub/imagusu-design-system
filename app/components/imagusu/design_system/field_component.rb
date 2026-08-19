# frozen_string_literal: true

module Imagusu
  module DesignSystem
    class FieldComponent < BaseComponent
      BOOLEAN_VALUES = [true, false].freeze

      attr_reader :described_by

      def initialize(control_id:, label:, label_suffix: nil, hint: nil, errors: [], required: false, disabled: false)
        @control_id = control_id.to_s
        @label = label.to_s
        @label_suffix = label_suffix.to_s unless label_suffix.nil? || label_suffix.to_s.empty?
        @hint = hint.to_s unless hint.nil? || hint.to_s.empty?
        @errors = Array(errors).compact.map(&:to_s).reject(&:empty?)
        @required = required
        @disabled = disabled
        @described_by = [hint_id, error_id].compact.join(" ").presence

        validate!
      end

      def control_attributes
        aria = {}
        aria[:describedby] = described_by if described_by
        aria[:invalid] = "true" if @errors.any?

        {
          id: @control_id,
          required: @required,
          disabled: @disabled,
          aria: aria
        }
      end

      private

      def validate!
        if @control_id.empty? || @control_id.match?(/[[:space:]]/)
          raise ArgumentError, "control_id must not be empty or contain whitespace"
        end
        raise ArgumentError, "label must not be empty" if @label.strip.empty?
        raise ArgumentError, "required must be true or false" unless BOOLEAN_VALUES.include?(@required)
        raise ArgumentError, "disabled must be true or false" unless BOOLEAN_VALUES.include?(@disabled)
      end

      def hint_id
        "#{@control_id}-hint" if @hint
      end

      def error_id
        "#{@control_id}-error" if @errors.any?
      end

      def error_text
        @errors.join(". ")
      end

      def state_tokens
        states = []
        states << "invalid" if @errors.any?
        states << "required" if @required
        states << "disabled" if @disabled
        states.empty? ? "default" : states.join(" ")
      end
    end
  end
end
