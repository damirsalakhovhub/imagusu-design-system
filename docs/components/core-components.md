# Button

Status: experimental

## Rendering

```erb
<%= render "imagusu/design_system/button",
  content: "Save",
  type: :submit,
  disabled: false,
  html_attributes: {
    id: "save-profile",
    form: "profile-form",
    data: { action: "profile#save" }
  } %>
```

Strict locals:

- `content:` — required nonblank plain text;
- `type:` — `:button` by default; also `:submit` or `:reset`;
- `disabled:` — `false` by default and always a boolean;
- `html_attributes:` — a Hash supporting `id`, `name`, `value`, `form`, `title`, `autofocus`, `data`, and non-owned `aria`.

Missing or unknown locals fail through Rails strict-locals enforcement.

## Semantic contract

- Output is one native `<button>`.
- Hook `ids-button` is component-owned.
- Visible content is the accessible name.
- Content and supported attributes are escaped by Rails.
- HTML-safe/rich content and `aria-label`, `aria-labelledby`, `aria-hidden`, `aria-disabled`, consumer classes, event-handler attributes, and conflicting type/disabled attributes are rejected.
- The consumer owns meaningful wording, form placement, event behavior, and valid targets for any external ARIA relationship.

IDS currently supports text-only buttons. Icon-only or rich-content buttons require a separate accessible-name and composition contract before implementation.

## Evidence boundary

Rendered tests cover native semantics, strict locals, escaping, supported state, and rejected conflicts. No skin exists, so contrast, focus appearance, target size, forced colors, zoom, and reflow are not yet claimed. A consuming page still owns task-level keyboard and assistive-technology testing.
