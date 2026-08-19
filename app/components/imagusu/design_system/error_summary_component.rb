# frozen_string_literal: true

module Imagusu
  module DesignSystem
    class ErrorSummaryComponent < Internal::PrimitiveComponent
      HTML_ATTRIBUTES = %i[data aria].freeze
      ENTRY_KEYS = %i[field_id message].freeze

      attr_reader :errors

      def initialize(errors:, title:, description: nil, id: "error-summary", **attributes)
        super(**attributes)
        @id = id.to_s
        @title = title.to_s
        @description = description.to_s unless description.nil? || description.to_s.empty?
        @errors = normalize_errors(errors)

        validate_html_id!(:id, @id)
        validate_nonempty_text!(:title, @title)
        validate_primitive_attributes!(allowed: HTML_ATTRIBUTES, owned_aria: [:labelledby])
      end

      private

      def container_attributes
        base = primitive_attributes(
          css_class: "ids-error-summary",
          allowed: HTML_ATTRIBUTES,
          owned_aria: [:labelledby]
        )
        base.merge(id: @id, tabindex: -1)
      end

      def alert_attributes
        {role: "alert", aria: {labelledby: title_id}}
      end

      def title_id
        "#{@id}-title"
      end

      def normalize_errors(value)
        raise ArgumentError, "errors must be a non-empty Array" unless value.is_a?(Array) && value.any?

        value.map do |entry|
          normalized = normalize_hash(entry, "error entry")
          unsupported = normalized.keys - ENTRY_KEYS
          unless unsupported.empty?
            raise ArgumentError, "unsupported error entry keys: #{unsupported.join(", ")}"
          end

          field_id = normalized[:field_id].to_s
          message = normalized[:message].to_s
          validate_html_id!(:field_id, field_id)
          raise ArgumentError, "field_id must not start with #" if field_id.start_with?("#")
          validate_nonempty_text!(:message, message)
          {field_id: field_id, message: message}
        end
      end
    end
  end
end
