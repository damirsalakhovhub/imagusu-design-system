# frozen_string_literal: true

module Imagusu
  module DesignSystem
    class AlertComponent < Internal::PrimitiveComponent
      TONES = %i[info success warning danger].freeze
      ANNOUNCEMENTS = [false, :polite, :assertive].freeze
      HTML_ATTRIBUTES = %i[id title data aria].freeze

      def initialize(title:, tone: :info, announce: false, heading_level: 2, **attributes)
        super(**attributes)
        @title = title.to_s
        @tone = tone.respond_to?(:to_sym) ? tone.to_sym : tone
        @announce = announce.respond_to?(:to_sym) ? announce.to_sym : announce
        @heading_level = heading_level

        validate_nonempty_text!(:title, @title)
        raise ArgumentError, "tone must be one of: #{TONES.join(", ")}" unless TONES.include?(@tone)
        raise ArgumentError, "announce must be false, polite, or assertive" unless ANNOUNCEMENTS.include?(@announce)
        raise ArgumentError, "heading_level must be between 2 and 6" unless (2..6).cover?(@heading_level)
        validate_primitive_attributes!(allowed: HTML_ATTRIBUTES, owned_aria: [:live])
        validate_owned_data!
      end

      private

      def attributes
        base = primitive_attributes(css_class: "ids-alert", allowed: HTML_ATTRIBUTES, owned_aria: [:live])
        base[:role] = announcement_role if announcement_role
        merge_owned_data(base, tone: @tone)
      end

      def announcement_role
        {polite: "status", assertive: "alert"}[@announce]
      end

      def heading_tag
        :"h#{@heading_level}"
      end

      def validate_owned_data!
        data = normalize_hash(@html_attributes.fetch(:data, {}), "data")
        raise ArgumentError, "component owns data attributes: tone" if data.key?(:tone)
      end
    end
  end
end
