# frozen_string_literal: true

module Imagusu
  module DesignSystem
    class FormControlsComponentPreview < ViewComponent::Preview
      def default
        render_with_template
      end

      def errors
        render_with_template
      end

      def disabled
        render_with_template
      end
    end
  end
end
