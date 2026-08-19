# frozen_string_literal: true

module Imagusu
  module DesignSystem
    class TextFieldComponent < Internal::FormControlComponent
      TYPES = %i[text email url tel search password].freeze
      HELPERS = {
        text: :text_field,
        email: :email_field,
        url: :url_field,
        tel: :telephone_field,
        search: :search_field,
        password: :password_field
      }.freeze
      HTML_ATTRIBUTES = %i[autocomplete autofocus data form inputmode list maxlength minlength pattern placeholder readonly size spellcheck].freeze

      def initialize(type: :text, value: Internal::FormControlComponent::UNSET, **attributes)
        super(**attributes)
        @type = type.respond_to?(:to_sym) ? type.to_sym : type
        @value = value

        raise ArgumentError, "type must be one of: #{TYPES.join(", ")}" unless TYPES.include?(@type)
        validate_html_attributes!(HTML_ATTRIBUTES)
      end

      def call
        attributes = control_attributes(css_class: "ids-input", allowed: HTML_ATTRIBUTES)
        attributes[:value] = @value unless @value.equal?(Internal::FormControlComponent::UNSET) || @type == :password

        render_with_field(form.public_send(HELPERS.fetch(@type), method, **attributes))
      end
    end
  end
end
