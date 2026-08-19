# ADR 0005: Localization boundary

Status: accepted

## Context

IDS needs a predictable localization contract without taking ownership of product language or mutating the consuming application's locale configuration. Component semantics, accessible names, descriptions, errors, and status messages must remain correct when translated, expanded, pluralized, or rendered in a right-to-left document.

## Decision

Use Rails I18n directly. Do not add a localization framework or require `rails-i18n`.

IDS owns only universal strings introduced by IDS behavior, such as an intrinsic close action or a component-generated status. These keys live under `imagusu_design_system.*`. The gem ships nonblank English values for every IDS-owned key before that key becomes public. Consumers may override shipped translations through normal Rails I18n load-path precedence.

Consumers own product and domain copy, including field labels, hints, validation messages, action names, headings, descriptions, and empty-state content. Components accept that copy through their public rendering API. IDS does not translate consumer-provided text or Active Model errors a second time.

Explicit component text overrides an IDS default. Visible text is the accessible-name source whenever possible; a separately translated `aria-label` must not duplicate or diverge from it. Icon-only controls require a nonblank accessible name.

Pluralization and interpolation use Rails I18n. IDS does not implement language rules. Translation values are plain text and are escaped by Rails. HTML-bearing translation conventions such as `_html` keys are outside the public contract; structured or formatted content is provided through safe rendering composition.

IDS respects `I18n.locale` but never sets the locale, fallback policy, available locales, exception handler, backend, or load path globally. The consuming application owns document `lang` and `dir`. Components inherit document direction and do not infer it from locale. Official skins use logical CSS properties and must tolerate right-to-left layout and expanded translations.

Translation keys, interpolation variables, and pluralization arguments used by public components are versioned public API. Renaming or removing them follows the normal breaking-change policy.

## Required evidence

Before the first IDS-owned string ships, add automated checks proving:

- every shipped English key is present and nonblank;
- a consumer locale can override the default;
- translated accessible names, hints, errors, and status text keep their semantic relationships;
- pluralized strings delegate through `count:`;
- missing keys fail tests instead of silently shipping placeholder output;
- an RTL pseudo-locale does not cause IDS to force left-to-right direction;
- a long-string pseudo-locale does not change semantic or focus order.

Browser checks for official skins cover RTL, long text, 200% text resize, 400% zoom, 320 CSS pixel reflow, forced colors, and reduced motion where applicable. Scripts cannot prove translation quality, cultural appropriateness, screen-reader pronunciation, or the accessibility of arbitrary consumer copy.

## Consequences

The foundation has no localization dependency beyond Rails. A component cannot hide product copy in internal defaults. Consumers retain full control over terminology and locale policy, while IDS-owned behavior remains consistently translatable and overrideable.
