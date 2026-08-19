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
- `type:` — `:button` by default; also `:submit`;
- `disabled:` — `false` by default and always a boolean;
- `html_attributes:` — a Hash supporting `id`, `name`, `value`, `form`, `data`, `aria-describedby`, and `aria-details`.

Missing or unknown locals fail through Rails strict-locals enforcement.

## Semantic contract

- Output is one native `<button>`.
- Hook `ids-button` is component-owned.
- Visible content is the accessible name.
- Content and supported attributes are escaped by Rails.
- HTML-safe/rich content, consumer classes, event-handler attributes, conflicting type/disabled attributes, and ARIA outside the two descriptive relationships are rejected.
- The consumer owns meaningful wording, form placement, event behavior, and valid targets for any external ARIA relationship.

## No-skin milestone

The text Button core is complete at `experimental` status. It deliberately has no `variant`, `size`, or `width` locals: without CSS they would be dormant public API rather than behavior.

The remaining family is explicitly deferred:

- visual variants, sizes, and width — until the official skin contract;
- LinkButton — until button presentation exists and a confirmed navigation case cannot use ordinary `link_to` clearly;
- IconButton — until a trusted icon composition and accessible-name contract exists;
- ButtonGroup — until a confirmed related-action grouping and label source exists;
- ToggleButton — until a server-rendered no-JavaScript state transition is proven or the behavior boundary changes;
- MenuButton and async/loading Button — until their keyboard, focus, announcement, failure, and no-JavaScript behavior is approved.

These deferrals are catalog scope, not public API. They do not prevent work from moving to Text input.

## Evidence boundary

Rendered tests cover native semantics, strict locals, escaping, supported state, and rejected conflicts. No skin exists, so contrast, focus appearance, target size, forced colors, zoom, and reflow are not yet claimed. A consuming page still owns task-level keyboard and assistive-technology testing.
