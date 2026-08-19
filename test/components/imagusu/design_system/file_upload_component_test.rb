# frozen_string_literal: true

require "test_helper"

class Imagusu::DesignSystem::FileUploadComponentTest < ViewComponent::TestCase
  def test_renders_native_file_input
    render_inline(component)

    assert_selector "label[for='user_document']", text: "Upload document"
    assert_selector "input.ids-file-upload#user_document[type='file'][name='user[document]']"
  end

  def test_supports_accept_multiple_and_external_form
    render_inline(component(
      multiple: true,
      html_attributes: {accept: "image/png,image/jpeg", form: "profile-form", data: {direct_upload: true}}
    ))

    assert_selector "input[type='file'][name='user[document][]'][multiple][accept='image/png,image/jpeg'][form='profile-form'][data-direct-upload='true']"
  end

  def test_connects_hint_errors_and_visible_required_copy
    render_inline(component(
      hint: "PDF, up to 10 MB",
      errors: ["Select a PDF file"],
      required: true,
      label_suffix: "(required)"
    ))

    assert_selector "label .ids-field__label-suffix", text: "(required)"
    assert_selector "input[required][aria-invalid='true'][aria-describedby='user_document-hint user_document-error']"
  end

  def test_rejects_invalid_multiple_and_attributes
    assert_raises(ArgumentError) { component(multiple: "false") }
    assert_raises(ArgumentError) { component(html_attributes: {value: "/tmp/private"}) }
    assert_raises(ArgumentError) { component(html_attributes: {onchange: "alert(1)"}) }
  end

  private

  def component(**attributes)
    defaults = {
      form: form_builder,
      method: :document,
      label: "Upload document"
    }

    Imagusu::DesignSystem::FileUploadComponent.new(**defaults.merge(attributes))
  end
end
