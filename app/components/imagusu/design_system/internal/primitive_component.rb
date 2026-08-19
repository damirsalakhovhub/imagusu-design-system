# frozen_string_literal: true

module Imagusu
  module DesignSystem
    module Internal
      class PrimitiveComponent < Imagusu::DesignSystem::BaseComponent
        BOOLEAN_VALUES = [true, false].freeze

        def initialize(classes: nil, html_attributes: {})
          @classes = classes
          @html_attributes = normalize_hash(html_attributes, "html_attributes")
        end

        private

        def primitive_attributes(css_class:, allowed:, owned_aria: [])
          validate_primitive_attributes!(allowed: allowed, owned_aria: owned_aria)

          attributes = @html_attributes.except(:aria)
          aria = normalize_hash(@html_attributes.fetch(:aria, {}), "aria")
          attributes[:aria] = aria unless aria.empty?
          attributes[:class] = class_names(css_class, @classes)
          attributes
        end

        def validate_primitive_attributes!(allowed:, owned_aria: [])
          unsupported = @html_attributes.keys - (allowed + [:aria])
          unless unsupported.empty?
            raise ArgumentError, "unsupported HTML attributes: #{unsupported.join(", ")}"
          end

          aria = normalize_hash(@html_attributes.fetch(:aria, {}), "aria")
          normalize_hash(@html_attributes[:data], "data") if @html_attributes.key?(:data)
          conflicts = aria.keys & owned_aria
          unless conflicts.empty?
            raise ArgumentError, "component owns ARIA attributes: #{conflicts.join(", ")}"
          end
        end

        def merge_owned_data(attributes, values)
          data = normalize_hash(attributes.fetch(:data, {}), "data")
          conflicts = data.keys & values.keys
          unless conflicts.empty?
            raise ArgumentError, "component owns data attributes: #{conflicts.join(", ")}"
          end

          attributes.merge(data: data.merge(values))
        end

        def validate_boolean!(name, value)
          return if BOOLEAN_VALUES.include?(value)

          raise ArgumentError, "#{name} must be true or false"
        end

        def validate_nonempty_text!(name, value)
          return unless value.to_s.strip.empty?

          raise ArgumentError, "#{name} must not be empty"
        end

        def validate_html_id!(name, value)
          if value.to_s.empty? || value.to_s.match?(/[[:space:]]/)
            raise ArgumentError, "#{name} must not be empty or contain whitespace"
          end
        end

        def normalize_hash(value, name)
          raise ArgumentError, "#{name} must be a Hash" unless value.is_a?(Hash)

          value.to_h do |key, item|
            raise ArgumentError, "#{name} keys must be strings or symbols" unless key.respond_to?(:to_sym)

            [key.to_sym, item]
          end
        end
      end
    end
  end
end
