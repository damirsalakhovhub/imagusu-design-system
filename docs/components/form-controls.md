# Text field

Status: experimental

## Rendering

```erb
<%= form_with model: @profile do |form| %>
  <%= render "imagusu/design_system/text_field",
    form: form,
    method: :email,
    label: "Email",
    type: :email,
    hint: "Used for account notifications",
    errors: :auto,
    required: true,
    disabled: false,
    html_attributes: { autocomplete: "email" } %>
<% end %>
```

Strict locals:

- `form:` — an ordinary Rails `ActionView::Helpers::FormBuilder`;
- `method:` — a nonblank bound method or scope key;
- `label:` — nonblank visible plain text;
- `type:` — `:text` by default; also `:email`, `:url`, `:tel`, `:search`, or `:password`;
- `hint:` — optional plain text;
- `errors:` — `:auto` by default; also `false`, `nil`, a String, or an Array;
- `required:` and `disabled:` — strict booleans;
- `html_attributes:` — `autocomplete`, `autofocus`, `data`, `form`, `inputmode`, `list`, `maxlength`, `minlength`, `pattern`, `placeholder`, `readonly`, `size`, `spellcheck`, and non-owned `aria`.

## Ownership

Rails FormBuilder owns:

- control IDs, names, bound values, nested indices, and type-specific field helpers;
- host `field_error_proc` behavior around the native input;
- password fields, which do not echo the bound value.

IDS owns:

- `div.ids-field`, `label.ids-field__label`, `ids-field__hint`, `ids-field__error`, and `input.ids-input`;
- DOM order: label, optional hint, optional error, then native input;
- hint/error IDs derived from the Rails field ID;
- merged and deduplicated `aria-describedby`;
- `aria-invalid="true"` only when an error is rendered;
- `data-state` tokens: `default`, `invalid`, `required`, and `disabled`.

The visible label is the accessible name. Consumer overrides of ID, name, type, class, value state, `aria-label`, `aria-labelledby`, `aria-invalid`, and other IDS-owned state are rejected.

Hooks identify their elements; direct-child relationships are not part of the skin contract. In particular, a host application's standard `field_error_proc` may wrap `input.ids-input` in `.field_with_errors`. Skins must target the hook itself rather than require `.ids-field > .ids-input`.

With `errors: :auto`, IDS reads existing `form.object.errors` and does not run validation. The consuming form owns server-side validation, authorization, an error summary, focus after failed submission, and dynamic announcements. Inline errors are not live regions by default.

## Evidence boundary

Rendered tests cover strict locals, nested names/IDs, bound values, escaping, password behavior, hint/error relationships, disabled/required state, and host error wrapping. The core works without CSS or JavaScript.

No official skin exists. Contrast, visible focus, target size, forced colors, zoom, and reflow remain skin evidence. Manual keyboard and assistive-technology checks are required before stable status.
