# frozen_string_literal: true

module Imagusu
  module DesignSystem
    class LinkComponent < Internal::PrimitiveComponent
      HTML_ATTRIBUTES = %i[id title target rel download hreflang referrerpolicy data aria].freeze
      UNSAFE_SCHEMES = %w[javascript: data: vbscript:].freeze

      def initialize(href:, **attributes)
        super(**attributes)
        @href = href.to_s

        validate_nonempty_text!(:href, @href)
        validate_href!
        validate_primitive_attributes!(allowed: HTML_ATTRIBUTES, owned_aria: [:hidden])
      end

      private

      def attributes
        primitive_attributes(css_class: "ids-link", allowed: HTML_ATTRIBUTES, owned_aria: [:hidden]).merge(href: @href)
      end

      def validate_href!
        normalized = @href.gsub(/[\u0000-\u0020]/, "").downcase
        return unless UNSAFE_SCHEMES.any? { |scheme| normalized.start_with?(scheme) }

        raise ArgumentError, "href uses an unsafe URL scheme"
      end
    end
  end
end
