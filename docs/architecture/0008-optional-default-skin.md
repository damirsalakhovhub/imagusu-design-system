# ADR 0008: Optional default skin and brand colours

Status: accepted; implementation pending

Supersedes [ADR 0002](0002-frontend-boundary.md) for CSS. JavaScript still requires a separate decision.

## Context

IDS needs visual Button variants and a useful default appearance without forcing that appearance on a Rails application that already has its own design language. A consumer that chooses IDS is assumed to want its component decisions; the supported customization goal is therefore small brand adjustment, not a universal theme builder.

The confirmed initial need is one official skin and the ability to replace its action and danger colours. Multiple official skins, success feedback, dark mode, arbitrary palettes, and independent skin releases remain possible future cases rather than current API promises.

## Decision

### Consumer modes

IDS supports three clear modes:

1. **Core only** — render the Rails partials and do not load IDS CSS. The host styles documented `.ids-*` hooks and `data-state` itself.
2. **Default skin** — explicitly load one namespaced stylesheet from the same gem.
3. **Default skin with brand colours** — load that stylesheet and override the small documented semantic colour contract.

Core rendering, semantics, form submission, and accessibility relationships must remain useful without CSS. IDS never injects a stylesheet, mutates the host layout, or adds Ruby theme configuration.

### Packaging

The first skin is one self-contained, browser-ready CSS asset planned at:

```text
app/assets/stylesheets/imagusu_design_system/skins/default.css
```

The intended Rails opt-in is:

```erb
<%= stylesheet_link_tag "imagusu_design_system/skins/default", "data-turbo-track": "reload" %>
```

The path is a target, not public API until the asset ships with package and host evidence. The asset uses no Sass, PostCSS, Tailwind, npm, JavaScript, external font, external URL, generator, `@import`, or new runtime dependency. The host asset pipeline owns fingerprinting, caching, and delivery. Rails documents namespaced Engine assets and explicit stylesheet linking in the [Engine guide](https://guides.rubyonrails.org/engines.html#assets) and [Asset Pipeline guide](https://guides.rubyonrails.org/asset_pipeline.html).

An additional skin stays outside the supported inventory until a real second visual use case exists. If one is later accepted, it is another self-contained opt-in stylesheet; a consumer loads exactly one official skin. A separate gem is justified only by a demonstrated independent owner, dependency, or release lifecycle.

### Skin and theme boundary

- **Core** owns semantic HTML, strict locals, DOM relationships, `.ids-*` hooks, `data-state`, ARIA, and behavior.
- **Skin** owns component presentation, system-font usage, spacing, shape, neutral colours, interaction-state colours, focus appearance, target size, forced-colour behavior, reflow, and visual state distinction.
- **Brand theme** overrides only documented semantic colour pairs.
- **Consumer** owns its chosen brand values, page background and layout, product content, and task-level accessibility.

The initial proposed brand surface is:

```text
--ids-color-accent
--ids-color-on-accent
--ids-color-danger
--ids-color-on-danger
```

These names are proposed and non-public until the Button skin ships. The two values in each pair are treated together so the foreground remains readable on the surface. `success/on-success` is added only when a shipped component has a success state. Neutral, focus, hover, active, spacing, radius, and component-internal values remain private until a consumer demonstrates a need.

The skin may derive hover and active colours internally only when it also supplies safe fallbacks and validates every resulting state. It does not claim arbitrary consumer overrides are accessible. CSS custom properties provide the native cascading mechanism for this boundary; no token compiler or theme registry is introduced. See the [CSS Custom Properties specification](https://www.w3.org/TR/css-variables-1/).

### CSS contract

- Target only documented `.ids-*`, native state, and `data-state` hooks.
- Do not depend on undocumented DOM ancestry or direct-child structure.
- Use low-specificity, namespaced selectors; no global reset, element-wide rules, `body` styling, or `!important`.
- Apply only `font-family` when setting the system font; do not use the `font` shorthand to change host sizes or line heights accidentally.
- Use logical properties and inherit document direction.
- Do not encode semantic behavior or confirmation in visual variants.

The stylesheet path, selectors, documented state values, and documented custom properties become versioned public API only when shipped under [ADR 0003](0003-public-api.md).

### Accessibility and evidence

The official skin must validate its default and derived states. Brand overrides make the consumer the theme author; IDS provides a preview and checking guidance but cannot certify arbitrary colours or host backgrounds.

For the first Button slice:

- text contrast passes WCAG 2.2 AA in default, hover, and active states;
- required control boundaries, states, and focus indicators reach 3:1 contrast;
- state is not communicated by colour alone;
- focus uses a robust two-colour treatment at least 2 CSS pixels thick, is not derived from the brand colour, and remains usable in forced-colours mode;
- ordinary targets aim for 44 by 44 CSS pixels and never depend on an exception below 24 by 24;
- long English/Russian/RTL text, user text-spacing overrides, 200% text resize, 400% zoom, and 320 CSS pixel reflow remain usable;
- fixed text-control heights are avoided.

Before `preview`, deterministic checks cover the no-skin path, the opt-in asset, package discovery in an installed Rails host, token overrides, documented states, and raw/compressed CSS bytes. The first implementation establishes a measured baseline rather than inventing a budget. Manual browser, zoom, forced-colours, keyboard, and assistive-technology evidence remains required before `stable` where applicable.

## Rejected now

- automatic stylesheet injection;
- a second gem or npm package;
- a theme provider, registry, generator, configuration DSL, or runtime switcher;
- a palette scale, JSON token graph, or public variable for every CSS declaration;
- multiple promised skins or presets without a consumer;
- a build tool or JavaScript for colour customization;
- accessibility guarantees for arbitrary third-party CSS.

## Implementation gate

This decision does not add CSS. The current policy and package smoke continue to reject frontend files. The first skin implementation must update those controls narrowly for the one approved asset, add the evidence in the [default skin plan](../plans/default-skin.md), and pass all five review roles.

## Consequences

The common path remains one gem and one optional stylesheet. A Rails product can accept the IDS appearance, make a small brand-colour adjustment, or keep only the semantic core. IDS gains a path to visual completeness without committing to a general-purpose theming platform.
