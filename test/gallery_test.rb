# frozen_string_literal: true

require "test_helper"

class GalleryTest < ActionDispatch::IntegrationTest
  test "renders every Rails-native public component state" do
    get "/gallery"

    assert_response :success
    assert_select "html[lang='en']"
    assert_select "title", text: "Imagusu Design System gallery"
    assert_select "main h1", text: "Imagusu Design System gallery"
    assert_select "button.ids-button", count: 3
    assert_select ".ids-field input.ids-input", count: 5
    assert_select "input[aria-invalid='true'][aria-describedby='profile_invalid_email-error']"
  end
end
