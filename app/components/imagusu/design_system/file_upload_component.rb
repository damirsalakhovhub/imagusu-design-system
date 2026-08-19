# frozen_string_literal: true

module Imagusu
  module DesignSystem
    class FileUploadComponent < Internal::FormControlComponent
      HTML_ATTRIBUTES = %i[accept autofocus capture data form].freeze

      def initialize(multiple: false, **attributes)
        super(**attributes)
        @multiple = multiple

        validate_boolean!(:multiple, @multiple)
        validate_html_attributes!(HTML_ATTRIBUTES)
      end

      def call
        attributes = control_attributes(css_class: "ids-file-upload", allowed: HTML_ATTRIBUTES)
        attributes[:multiple] = @multiple
        render_with_field(form.file_field(method, **attributes))
      end
    end
  end
end
