# ADR 0005: Localization boundary

Status: accepted

## Context

IDS needs a predictable localization contract without taking ownership of product language or mutating the consuming application's locale configuration. Component semantics, accessible names, descriptions, errors, and status messages must remain correct when translated, expanded, pluralized, or rendered in a right-to-left document.

## Decision

Use Rails I18n directly. Do not add a localization framework or require `rails-i18n`.

IDS owns only universal strings introduced by IDS behavior, such as an intrinsic close action or a component-generated status. These keys live under `imagusu_design_system.*`.

English is the canonical source locale and Russian ships in key parity. Every IDS-owned key must add nonblank English and Russian values in the same change. Consumers may select Russian through ordinary Rails configuration and may override either locale through normal I18n load-path precedence. Until a component owns universal text, the packaged locale namespaces remain intentionally empty; IDS does not invent copy to exercise infrastructure.

Consumers own product and domain copy, including field labels, hints, validation messages, action names, headings, descriptions, and empty-state content. Components accept that copy through their public rendering API. IDS does not translate consumer-provided text or Active Model errors a second time.

Explicit component text overrides an IDS default. Visible text is the accessible-name source whenever possible; a separately translated `aria-label` must not duplicate or diverge from it. Icon-only controls require a nonblank accessible name.

Interpolation uses Rails I18n. IDS does not implement language rules. The default I18n backend does not provide the full Russian plural rule set, so IDS-owned plural maps are prohibited until a host-independent rule strategy is separately approved; `rails-i18n` is not added automatically. Until that decision, EN/RU message keys and interpolation variables must match exactly. Translation values are plain text and are escaped by Rails. HTML-bearing translation conventions such as `_html` keys are outside the public contract; structured or formatted content is provided through safe rendering composition.

IDS respects `I18n.locale` but never sets the locale, default locale, fallback policy, available locales, exception handler, or backend globally. Rails Engine discovery adds the packaged locale files to the ordinary load path. The consuming application owns its active/default locale and document `lang` and `dir`. Components inherit document direction and do not infer it from locale. Official skins use logical CSS properties and must tolerate right-to-left layout and expanded translations.

Translation keys, interpolation variables, and pluralization arguments used by public components are versioned public API. Renaming or removing them follows the normal breaking-change policy.

## Required evidence

Locale packaging checks prove that both namespace files are shipped, discovered by the Engine, and have identical key sets. For every IDS-owned string, automated checks additionally prove:

- English and Russian have identical, nonblank key sets;
- a consumer locale can override the default;
- missing keys fail tests instead of silently shipping placeholder output.

Add the following evidence when the corresponding feature first uses it:

- translated accessible names, hints, errors, and status text keep their semantic relationships;
- pluralized strings delegate through `count:` after the plural-rule decision supersedes the current prohibition;
- an RTL pseudo-locale does not cause IDS to force left-to-right direction;
- a long-string pseudo-locale does not change semantic or focus order.

Browser checks for official skins cover RTL, long text, 200% text resize, 400% zoom, 320 CSS pixel reflow, forced colors, and reduced motion where applicable. Scripts cannot prove translation quality, cultural appropriateness, screen-reader pronunciation, or the accessibility of arbitrary consumer copy.

## Consequences

The foundation has no localization dependency beyond Rails. IDS ships `en` and `ru` resources without changing a host application's locale policy. A component cannot hide product copy in internal defaults. Consumers retain full control over terminology and locale policy, while IDS-owned behavior remains consistently translatable and overrideable.
