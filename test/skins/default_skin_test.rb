# frozen_string_literal: true

require "digest"
require "stringio"
require "zlib"
require "test_helper"

class DefaultSkinTest < ActiveSupport::TestCase
  ROOT = Pathname(__dir__).join("../..").expand_path
  CSS_PATH = ROOT.join("app/assets/stylesheets/imagusu_design_system/skins/default.css")
  EVIDENCE_PATH = ROOT.join("docs/components/core-components.md")
  GALLERY_LAYOUT_PATH = ROOT.join("test/dummy/app/views/layouts/gallery.html.erb")
  GALLERY_PATH = ROOT.join("test/dummy/app/views/gallery/show.html.erb")

  OFFICIAL_TEXT_PAIRS = {
    secondary: ["#111827", "#f3f4f6"],
    primary: ["#ffffff", "#2563eb"],
    plain: ["#111827", "#ffffff"],
    danger: ["#ffffff", "#b42318"],
    disabled: ["#4b5563", "#e5e7eb"]
  }.freeze

  BRAND_FIXTURES = {
    brand_accent: ["#ffffff", "#0f766e"],
    brand_danger: ["#ffffff", "#9f1239"]
  }.freeze

  test "keeps the skin component-scoped and dependency-free" do
    css = CSS_PATH.read

    assert_includes css, ".ids-button {"
    assert_includes css, "font-family: system-ui"
    refute_match(/(^|[;{])\s*font\s*:/, css)
    refute_match(/(^|})\s*:root\b/, css)
    refute_match(/(^|})\s*(?:html|body|button)\b/, css)
    refute_match(/@import\b/, css)
    refute_match(/url\s*\(/, css)
    refute_includes css, "!important"
    refute_includes css, "color-mix("
  end

  test "publishes only the approved brand pairs with official fallbacks" do
    css = CSS_PATH.read

    assert_includes css, "var(--ids-color-accent, #2563eb)"
    assert_includes css, "var(--ids-color-on-accent, #ffffff)"
    assert_includes css, "var(--ids-color-danger, #b42318)"
    assert_includes css, "var(--ids-color-on-danger, #ffffff)"
    assert_equal 2, css.scan("--ids-color-accent").length
    assert_equal 1, css.scan("--ids-color-on-accent").length
    assert_equal 2, css.scan("--ids-color-danger").length
    assert_equal 1, css.scan("--ids-color-on-danger").length
  end

  test "covers target size focus state and forced colours" do
    css = CSS_PATH.read

    assert_includes css, "min-block-size: max(2.75rem, 44px)"
    assert_includes css, "min-inline-size: max(2.75rem, 44px)"
    assert_includes css, ".ids-button:focus-visible"
    assert_includes css, "outline: 2px solid #ffffff"
    assert_includes css, "box-shadow: 0 0 0 4px #111827"
    assert_includes css, "@media (forced-colors: active)"
    assert_includes css, "border-color: GrayText"
    assert_includes css, "outline: 3px solid Highlight"
  end

  test "official and documented brand fixtures pass text contrast" do
    OFFICIAL_TEXT_PAIRS.merge(BRAND_FIXTURES).each do |name, (foreground, background)|
      assert_operator contrast_ratio(foreground, background), :>=, 4.5,
        "#{name} text contrast"
    end

    assert_operator contrast_ratio("#6b7280", "#ffffff"), :>=, 3.0,
      "secondary boundary contrast"
  end

  test "contrast fixtures match their CSS and gallery sources" do
    css = CSS_PATH.read
    gallery = GALLERY_PATH.read
    gallery_layout = GALLERY_LAYOUT_PATH.read

    assert_source_pair(css, ".ids-button", foreground: "#111827", background: "#f3f4f6")
    assert_includes declarations_for(css, ".ids-button"), "--_ids-button-border: #6b7280"
    assert_source_pair(css, ".ids-button--primary", foreground: "#ffffff", background: "#2563eb")
    assert_source_pair(css, ".ids-button--danger", foreground: "#ffffff", background: "#b42318")
    assert_source_pair(css, ".ids-button:disabled", foreground: "#4b5563", background: "#e5e7eb")

    plain_declarations = declarations_for(css, ".ids-button--plain")
    assert_includes plain_declarations, "--_ids-button-foreground: #111827"
    assert_includes plain_declarations, "--_ids-button-background: transparent"
    assert_includes gallery_layout, "background-color: #ffffff"

    assert_includes gallery, "--ids-color-accent: #{BRAND_FIXTURES.fetch(:brand_accent).last}"
    assert_includes gallery, "--ids-color-on-accent: #{BRAND_FIXTURES.fetch(:brand_accent).first}"
    assert_includes gallery, "--ids-color-danger: #{BRAND_FIXTURES.fetch(:brand_danger).last}"
    assert_includes gallery, "--ids-color-on-danger: #{BRAND_FIXTURES.fetch(:brand_danger).first}"
  end

  test "hover and active keep the contrast-checked foreground and background" do
    css = CSS_PATH.read
    state_blocks = {
      hover: css[/\.ids-button:not\(:disabled\):hover\s*\{([^}]*)\}/m, 1],
      active: css[/\.ids-button:not\(:disabled\):active\s*\{([^}]*)\}/m, 1]
    }

    state_blocks.each do |state, declarations|
      assert declarations, "#{state} declarations must exist"
      refute_match(/(?:^|\n)\s*(?:background(?:-color)?|color|opacity)\s*:/, declarations,
        "#{state} must preserve the contrast-checked colour pair")
    end
  end

  test "records raw and deterministic gzip bytes against the CSS digest" do
    css = CSS_PATH.binread
    evidence = EVIDENCE_PATH.read

    assert_includes evidence, "SHA-256 `#{Digest::SHA256.hexdigest(css)}`"
    assert_includes evidence, "#{css.bytesize} raw bytes"
    assert_includes evidence, "#{gzip(css).bytesize} gzip bytes"
  end

  private

  def assert_source_pair(css, selector, foreground:, background:)
    declarations = declarations_for(css, selector)

    assert declarations, "#{selector} declarations must exist"
    assert_match(/--_ids-button-foreground: (?:var\([^,]+, )?#{Regexp.escape(foreground)}\)?;/, declarations)
    assert_match(/--_ids-button-background: (?:var\([^,]+, )?#{Regexp.escape(background)}\)?;/, declarations)
  end

  def declarations_for(css, selector)
    css[/#{Regexp.escape(selector)}\s*\{([^}]*)\}/m, 1]
  end

  def gzip(content)
    output = StringIO.new
    writer = Zlib::GzipWriter.new(output, Zlib::BEST_COMPRESSION)
    writer.mtime = 0
    writer.write(content)
    writer.close
    output.string
  end

  def contrast_ratio(first, second)
    lighter, darker = [relative_luminance(first), relative_luminance(second)].sort.reverse
    (lighter + 0.05) / (darker + 0.05)
  end

  def relative_luminance(hex)
    red, green, blue = hex.delete_prefix("#").scan(/../).map do |channel|
      value = channel.to_i(16) / 255.0
      (value <= 0.04045) ? (value / 12.92) : (((value + 0.055) / 1.055)**2.4)
    end

    (0.2126 * red) + (0.7152 * green) + (0.0722 * blue)
  end
end
