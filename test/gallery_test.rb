# frozen_string_literal: true

require "test_helper"

class GalleryTest < ActionDispatch::IntegrationTest
  test "renders the documented gallery examples" do
    get "/gallery"

    assert_response :success
    assert_select "html[lang='en']"
    assert_select "title", text: "Imagusu Design System gallery"
    assert_select "main h1", text: "Imagusu Design System gallery"
    assert_select "button.ids-button[type='button']", text: "Button"
    assert_select "button.ids-button[type='submit']", text: "Submit"
    assert_select "button.ids-button[disabled]", text: "Disabled"
    assert_select ".ids-field input.ids-input", count: 5
    assert_select "#profile_email-hint", text: "We will only use this for account messages"
    assert_select "input[aria-invalid='true'][aria-describedby='profile_invalid_email-error']"
    assert_select "input#profile_password[type='password'][required]:not([value])"
    assert_select "input#profile_disabled[disabled]"
  end
end
