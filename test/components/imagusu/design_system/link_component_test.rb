# frozen_string_literal: true

require "test_helper"

class Imagusu::DesignSystem::LinkComponentTest < ViewComponent::TestCase
  def test_renders_link_with_safe_attributes
    render_inline(component(
      href: "/profiles/1",
      classes: "profile-link",
      html_attributes: {data: {turbo: false}, aria: {current: "page"}}
    )) { "Profile" }

    assert_selector "a.ids-link.profile-link[href='/profiles/1'][data-turbo='false'][aria-current='page']", text: "Profile"
  end

  def test_allows_common_non_executable_urls
    ["#content", "https://example.com", "mailto:team@example.com", "tel:+77000000000"].each do |href|
      render_inline(component(href: href)) { "Destination" }
      assert_selector "a[href='#{href}']"
    end
  end

  def test_escapes_content_and_title
    result = render_inline(component(href: "/", html_attributes: {title: "<Title>"})) { "<script>alert(1)</script>" }

    assert_no_selector "script"
    assert_equal "<Title>", result.at_css("a")["title"]
    assert_text "<script>alert(1)</script>"
  end

  def test_rejects_empty_or_executable_urls
    ["", " ", "javascript:alert(1)", "java\nscript:alert(1)", "DATA:text/html,test", "vbscript:test"].each do |href|
      assert_raises(ArgumentError) { component(href: href) }
    end
  end

  def test_rejects_disabled_event_and_hidden_accessibility_state
    assert_raises(ArgumentError) { component(href: "/", html_attributes: {disabled: true}) }
    assert_raises(ArgumentError) { component(href: "/", html_attributes: {onclick: "alert(1)"}) }
    assert_raises(ArgumentError) { component(href: "/", html_attributes: {aria: {hidden: true}}) }
  end

  private

  def component(**attributes)
    Imagusu::DesignSystem::LinkComponent.new(**attributes)
  end
end
