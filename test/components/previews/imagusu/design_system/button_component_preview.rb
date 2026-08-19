# frozen_string_literal: true

module Imagusu
  module DesignSystem
    class ButtonComponentPreview < ViewComponent::Preview
      def default
        render ButtonComponent.new do
          "Button"
        end
      end

      def submit
        render ButtonComponent.new(type: :submit) do
          "Submit"
        end
      end

      def disabled
        render ButtonComponent.new(disabled: true) do
          "Disabled"
        end
      end
    end
  end
end
