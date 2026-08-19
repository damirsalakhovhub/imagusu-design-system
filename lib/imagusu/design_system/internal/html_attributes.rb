# frozen_string_literal: true

module Imagusu
  module DesignSystem
    module Internal
      module HTMLAttributes
        module_function

        def normalize(value, allowed:, owned_aria:, owner:)
          raise ArgumentError, "html_attributes must be a Hash" unless value.is_a?(Hash)

          attributes = value.symbolize_keys
          attributes.assert_valid_keys(*allowed, :aria)

          aria = attributes.fetch(:aria, {})
          raise ArgumentError, "aria must be a Hash" unless aria.is_a?(Hash)

          normalized_aria = aria.symbolize_keys
          conflicts = normalized_aria.keys & owned_aria
          unless conflicts.empty?
            raise ArgumentError, "#{owner} owns ARIA attributes: #{conflicts.join(", ")}"
          end

          attributes.merge(aria: normalized_aria)
        end
      end
    end
  end
end
