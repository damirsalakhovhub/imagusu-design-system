# frozen_string_literal: true

module Imagusu
  module DesignSystem
    class ButtonComponent < BaseComponent
      TYPES = %i[button submit reset].freeze
      HTML_ATTRIBUTES = %i[id name value form title autofocus data aria].freeze

      def initialize(type: :button, disabled: false, html_attributes: {})
        @type = type.respond_to?(:to_sym) ? type.to_sym : type
        @disabled = disabled
        @html_attributes = html_attributes

        validate_type!
        validate_disabled!
        validate_html_attributes!
      end

      private

      def attributes
        @html_attributes.merge(type: @type, disabled: @disabled)
      end

      def validate_type!
        return if TYPES.include?(@type)

        raise ArgumentError, "type must be one of: #{TYPES.join(", ")}"
      end

      def validate_html_attributes!
        unless @html_attributes.is_a?(Hash)
          raise ArgumentError, "html_attributes must be a Hash"
        end

        unsupported = @html_attributes.keys.reject do |key|
          key.respond_to?(:to_sym) && HTML_ATTRIBUTES.include?(key.to_sym)
        end
        return if unsupported.empty?

        raise ArgumentError, "unsupported HTML attributes: #{unsupported.join(", ")}"
      end

      def validate_disabled!
        return if @disabled == true || @disabled == false

        raise ArgumentError, "disabled must be true or false"
      end
    end
  end
end
