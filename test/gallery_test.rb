# frozen_string_literal: true

require "test_helper"

class GalleryTest < ActionDispatch::IntegrationTest
  test "renders the documented gallery examples" do
    get "/gallery"

    assert_response :success
    assert_select "html[lang='en']"
    assert_select "body.ids-gallery"
    assert_includes response.body, "font-family: system-ui, sans-serif"
    assert_includes response.body, ":where(button, input, select, textarea)"
    assert_includes response.body, "font-family: inherit"
    refute_includes response.body, "font: inherit"
    assert_select "title", text: "Imagusu Design System gallery"
    assert_select "link[rel='icon'][href='/ids-favicon.svg'][type='image/svg+xml']"
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

  test "serves the IDS gallery favicon" do
    get "/ids-favicon.svg"

    assert_response :success
    assert_equal "image/svg+xml", response.media_type
    assert_includes response.body, "#2563EB"
  end
end
