# frozen_string_literal: true

require "test_helper"

class GalleryTest < ActionDispatch::IntegrationTest
  test "renders the documented gallery examples" do
    get "/gallery"

    assert_response :success
    assert_select "html[lang='en']"
    assert_select "body.ids-gallery"
    assert_includes response.body, "font-family: system-ui, sans-serif"
    assert_includes response.body, ":where(input, select, textarea)"
    assert_includes response.body, "font-family: inherit"
    refute_includes response.body, "font: inherit"
    assert_select "title", text: "Imagusu Design System gallery"
    assert_select "link[rel='icon'][href='/ids-favicon.svg'][type='image/svg+xml']"
    assert_select "main h1", text: "Imagusu Design System gallery"
    assert_select "link[rel='stylesheet'][href^='/assets/imagusu_design_system/skins/default-'][href$='.css']", count: 1
    assert_select "script", count: 0
    assert_select "button.ids-button[type='button']", text: "Secondary"
    assert_select "button.ids-button.ids-button--primary", text: "Primary"
    assert_select "button.ids-button.ids-button--plain", text: "Plain"
    assert_select "button.ids-button.ids-button--danger", text: "Danger"
    assert_select "button.ids-button.ids-button--small", text: "Small"
    assert_select "button.ids-button.ids-button--large", text: "Large"
    assert_select "button.ids-button.ids-button--full", text: "Full width"
    assert_select "button.ids-button.ids-button--primary[type='submit']", text: "Submit"
    assert_select "button.ids-button[disabled]", text: "Disabled"
    assert_select ".ids-gallery-row[style*='--ids-color-accent: #0f766e'] button.ids-button--primary", text: "Brand primary"
    assert_select ".ids-field input.ids-input", count: 5
    assert_select "#profile_email-hint", text: "We will only use this for account messages"
    assert_select "input[aria-invalid='true'][aria-describedby='profile_invalid_email-error']"
    assert_select "input#profile_password[type='password'][required]:not([value])"
    assert_select "input#profile_disabled[disabled]"
  end

  test "serves the one opt-in IDS stylesheet through Propshaft" do
    get "/gallery"
    stylesheet_href = css_select("link[rel='stylesheet']").sole["href"]

    get stylesheet_href

    assert_response :success
    assert_equal "text/css", response.media_type
    assert_includes response.body, ".ids-button"
    assert_includes response.body, "--ids-color-accent"
  end

  test "serves the IDS gallery favicon" do
    get "/ids-favicon.svg"

    assert_response :success
    assert_equal "image/svg+xml", response.media_type
    assert_includes response.body, "#2563EB"
  end
end
