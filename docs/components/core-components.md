# Button

Status: preview

## Rendering

```erb
<%= render "imagusu/design_system/button",
  content: "Save",
  type: :submit,
  disabled: false,
  variant: :primary,
  size: :medium,
  width: :auto,
  html_attributes: {
    id: "save-profile",
    form: "profile-form",
    data: { action: "profile#save" }
  } %>
```

Strict locals:

- `content:` — required nonblank plain text;
- `type:` — `:button` by default; also `:submit`;
- `disabled:` — `false` by default and always a boolean;
- `variant:` — `:secondary` by default; also `:primary`, `:plain`, or `:danger`;
- `size:` — `:medium` by default; also `:small` or `:large`;
- `width:` — `:auto` by default; also `:full`;
- `html_attributes:` — a Hash supporting `id`, `name`, `value`, `form`, `data`, `aria-describedby`, and `aria-details`.

Missing or unknown locals fail through Rails strict-locals enforcement.

## Semantic contract

- Output is one native `<button>`.
- Hook `ids-button` is component-owned.
- Non-default presentation hooks are `ids-button--primary`, `ids-button--plain`, `ids-button--danger`, `ids-button--small`, `ids-button--large`, and `ids-button--full`. Default `secondary`/`medium`/`auto` output keeps only `ids-button`.
- Visible content is the accessible name.
- Content and supported attributes are escaped by Rails.
- HTML-safe/rich content, consumer classes, event-handler attributes, conflicting type/disabled attributes, and ARIA outside the two descriptive relationships are rejected.
- The consumer owns meaningful wording, form placement, event behavior, and valid targets for any external ARIA relationship.

## Optional default skin

Core remains functional without CSS. A Rails host opts into the official skin explicitly:

```erb
<%= stylesheet_link_tag "imagusu_design_system/skins/default", "data-turbo-track": "reload" %>
```

The skin supports secondary, primary, plain, danger, disabled, small, medium, large, auto-width, and full-width presentation. Every size keeps a minimum 44 by 44 CSS-pixel target. `danger` is visual emphasis only; confirmation and authorization remain consumer-flow behavior.

Brand adjustment is limited to paired foreground/background values on a suitable ancestor:

```css
.your-brand-scope {
  --ids-color-accent: #0f766e;
  --ids-color-on-accent: #ffffff;
  --ids-color-danger: #9f1239;
  --ids-color-on-danger: #ffffff;
}
```

IDS validates the bundled defaults and these gallery fixtures. A consumer overriding a pair owns its contrast against every host background and state.

Skin baseline: SHA-256 `2194e83c0d4fb9cb92b79635adae9e0a313f478e00ec4c2a3f8c3bbf854f2018`, 2556 raw bytes and 840 gzip bytes, measured with Ruby 3.4.5 and zlib 1.2.12. The deterministic gzip measurement uses level 9 and mtime 0; it is a baseline, not a universal budget.

## Deferred Button family

The remaining family is explicitly deferred:

- LinkButton — until button presentation exists and a confirmed navigation case cannot use ordinary `link_to` clearly;
- IconButton — until a trusted icon composition and accessible-name contract exists;
- ButtonGroup — until a confirmed related-action grouping and label source exists;
- ToggleButton — until a server-rendered no-JavaScript state transition is proven or the behavior boundary changes;
- MenuButton and async/loading Button — until their keyboard, focus, announcement, failure, and no-JavaScript behavior is approved.

These deferrals are catalog scope, not public API. They do not prevent work from moving to Text input.

## Evidence boundary

Rendered tests cover native semantics, strict locals, escaping, supported state, rejected conflicts, and each presentation axis independently. Skin tests cover the approved asset boundary, public token fallbacks, official text contrast pairs, focus/forced-colour rules, target minimums, and recorded bytes. The installed-package smoke test compiles and resolves the digested stylesheet through Propshaft.

Manual keyboard, zoom/reflow, text-spacing, forced-colour, and broad browser evidence remains planned before `stable`. A consuming page still owns task-level keyboard, assistive-technology, page-background, and custom-theme testing.
