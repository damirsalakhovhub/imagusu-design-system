# frozen_string_literal: true

module Imagusu
  module DesignSystem
    class BadgeComponent < Internal::PrimitiveComponent
      TONES = %i[neutral accent info success warning danger].freeze
      HTML_ATTRIBUTES = %i[id title data aria].freeze

      def initialize(tone: :neutral, **attributes)
        super(**attributes)
        @tone = tone.respond_to?(:to_sym) ? tone.to_sym : tone

        raise ArgumentError, "tone must be one of: #{TONES.join(", ")}" unless TONES.include?(@tone)
        validate_primitive_attributes!(allowed: HTML_ATTRIBUTES)
        validate_owned_data!
      end

      private

      def attributes
        base = primitive_attributes(css_class: "ids-badge", allowed: HTML_ATTRIBUTES)
        merge_owned_data(base, tone: @tone)
      end

      def validate_owned_data!
        data = normalize_hash(@html_attributes.fetch(:data, {}), "data")
        raise ArgumentError, "component owns data attributes: tone" if data.key?(:tone)
      end
    end
  end
end
