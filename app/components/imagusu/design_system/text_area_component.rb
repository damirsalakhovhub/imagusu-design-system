# frozen_string_literal: true

module Imagusu
  module DesignSystem
    class TextAreaComponent < Internal::FormControlComponent
      HTML_ATTRIBUTES = %i[autocomplete autofocus cols data form maxlength minlength placeholder readonly rows spellcheck wrap].freeze

      def initialize(value: Internal::FormControlComponent::UNSET, **attributes)
        super(**attributes)
        @value = value
        validate_html_attributes!(HTML_ATTRIBUTES)
      end

      def call
        attributes = control_attributes(css_class: "ids-textarea", allowed: HTML_ATTRIBUTES)
        attributes[:value] = @value unless @value.equal?(Internal::FormControlComponent::UNSET)

        render_with_field(form.text_area(method, **attributes))
      end
    end
  end
end
