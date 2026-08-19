# frozen_string_literal: true

module Imagusu
  module DesignSystem
    class CoreComponentsComponentPreview < ViewComponent::Preview
      def default
        render_with_template
      end

      def tones
        render_with_template
      end

      def form_controls
        render_with_template
      end
    end
  end
end
