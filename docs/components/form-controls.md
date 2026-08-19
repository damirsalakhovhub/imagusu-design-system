# Form controls

Status: experimental

## Contract

Form controls require a Rails `FormBuilder`, a model method, and a visible label or legend. Rails owns parameter names, IDs, object values, nested indices, selected state, and hidden submission inputs. IDS owns visible field anatomy, hint and error IDs, ARIA relationships, state tokens, and styling hooks.

Typed controls accept:

- `form:` — the current Rails builder;
- `method:` — model or scope field;
- `label:` — non-empty visible label or legend;
- `label_suffix:` — optional visible, escaped suffix for localized required/optional copy;
- `hint:` — optional plain text;
- `errors:` — `:auto`, `false`, `nil`, or plain-text messages;
- `required:` and `disabled:` — strict booleans;
- `classes:` — additional control classes;
- `html_attributes:` — a component-specific allowlist plus nested `data:` and `aria:`.

With `errors: :auto`, the component reads existing `form.object.errors` without running validation. Consumer `aria-describedby` tokens are preserved and merged with generated hint and error IDs. `aria-invalid="true"` appears only when an error is rendered and cannot be overridden. The component does not invent locale-specific required copy: when `required: true`, include visible text in `label:` or `label_suffix:`.

## Components

### FieldComponent

Low-level wrapper for a custom native control. It accepts `control_id:`, `label:`, `label_suffix:`, `hint:`, `errors:`, `required:`, and `disabled:`. It renders label, hint, error, and state hooks and exposes `control_attributes`, which must be passed to the native control. Prefer the typed components below when one exists.

```erb
<% field = Imagusu::DesignSystem::FieldComponent.new(control_id: "query", label: "Search") %>
<%= render field do %>
  <%= search_field_tag :query, nil, **field.control_attributes %>
<% end %>
```

### TextFieldComponent

Types: `text`, `email`, `url`, `tel`, `search`, and `password`. Password values are never echoed through the explicit `value:` override. Allowed control attributes: `autocomplete`, `autofocus`, `data`, `form`, `inputmode`, `list`, `maxlength`, `minlength`, `pattern`, `placeholder`, `readonly`, `size`, `spellcheck`, and non-owned `aria` attributes. Hook: `ids-input`.

### TextAreaComponent

Uses the builder's bound value unless `value:` is explicit. Allowed control attributes: `autocomplete`, `autofocus`, `cols`, `data`, `form`, `maxlength`, `minlength`, `placeholder`, `readonly`, `rows`, `spellcheck`, `wrap`, and non-owned `aria` attributes. Hook: `ids-textarea`.

### SelectComponent

Uses native `<select>` and option pairs such as `[["Member", "member"]]`. Supports `selected:`, `prompt:`, `include_blank:`, `multiple:`, `include_hidden:`, and `disabled_values:`. For multiple fields, Rails owns the `[]` name and blank hidden input. Allowed control attributes: `autofocus`, `data`, `form`, `size`, and non-owned `aria` attributes. Hook: `ids-select`.

### CheckboxComponent

Uses `form.checkbox`, including Rails' hidden unchecked value by default. Supports `checked:`, `checked_value:`, `unchecked_value:`, and `include_hidden:`. Set `include_hidden: false` for array-style nested fields where a hidden value would create a ghost item. Allowed control attributes: `autofocus`, `data`, `form`, and non-owned `aria` attributes. Hooks: `ids-field--checkbox`, `ids-checkbox`, `ids-checkbox__control`, `ids-checkbox__label`.

### RadioGroupComponent

Uses native radios inside `<fieldset><legend>`. Values must be non-empty and produce unique Rails HTML IDs. Supports `selected:`, `include_hidden:`, and `disabled_values:`. Allowed fieldset attributes: `data`, `form`, and non-owned `aria` attributes. Hooks: `ids-radio-group`, `ids-radio-group__legend`, `ids-radio-group__options`, `ids-radio-group__option`, `ids-radio-group__control`, `ids-radio-group__label`.

## Markup order and hooks

TextField, TextArea, and Select render `div.ids-field` with label, hint, error, then the native control. Checkbox renders its native control and label together, followed by hint and error. RadioGroup renders fieldset, legend, hint, error, then the native radio options. Rails hidden submission inputs remain adjacent to their associated native controls. Common hooks are `ids-field`, `ids-field__label`, `ids-field__label-suffix`, `ids-field__hint`, and `ids-field__error`.

## States and security

Field wrappers expose space-separated `data-state` tokens: `default`, `invalid`, `required`, and `disabled`. Native `required`, `disabled`, `checked`, `selected`, and `multiple` attributes retain browser behavior. Disabled and unchecked controls have different submission semantics; client validation and option lists are never a server-side security boundary.

Labels, hints, errors, values, option content, and supported attributes use Rails escaping. Component-owned `id`, `name`, `type`, value state, `aria-label`, `aria-labelledby`, `aria-invalid`, and `aria-describedby` cannot be supplied through `html_attributes`; the visible label remains the accessible name.

## Page responsibilities

The consuming form still owns server-side validation, authorization, an error summary, focus movement after a failed submission, and dynamic error announcements. Do not add `role="alert"` to every initially rendered inline error.

Before stable status, manually verify keyboard operation and announcements with VoiceOver/Safari and NVDA/Firefox or Chrome. Consumer styles must retain visible focus, forced-colors support, reflow at 400%, and non-color error cues.
