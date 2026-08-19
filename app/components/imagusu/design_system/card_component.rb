# frozen_string_literal: true

module Imagusu
  module DesignSystem
    class CardComponent < Internal::PrimitiveComponent
      TAGS = %i[div article section li].freeze
      HTML_ATTRIBUTES = %i[id title data aria].freeze

      renders_one :header
      renders_one :footer

      def initialize(as: :div, **attributes)
        super(**attributes)
        @as = as.respond_to?(:to_sym) ? as.to_sym : as

        raise ArgumentError, "as must be one of: #{TAGS.join(", ")}" unless TAGS.include?(@as)
        validate_primitive_attributes!(allowed: HTML_ATTRIBUTES)
      end

      private

      def attributes
        primitive_attributes(css_class: "ids-card", allowed: HTML_ATTRIBUTES)
      end
    end
  end
end
