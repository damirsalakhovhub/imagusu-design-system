# Core components

Status: experimental

These server-rendered components expose semantic markup and stable `ids-*` class and `data-*` hooks without CSS or JavaScript. Text content and supported attributes are escaped by Rails. Event-handler attributes are not accepted.

## LinkComponent

Renders a native anchor. `href:` must be non-empty; `javascript:`, `data:`, and `vbscript:` URLs are rejected. Supported attributes are `id`, `title`, `target`, `rel`, `download`, `hreflang`, `referrerpolicy`, `data`, and `aria`. There is no disabled state: use a button for actions and omit unavailable navigation.

## AlertComponent

Requires a visible `title:` and accepts `tone: :info`, `:success`, `:warning`, or `:danger`. `heading_level:` is 2 through 6. Static SSR content has no live-region role by default; use `announce: :polite` only for dynamically inserted status updates and `announce: :assertive` only for urgent dynamic errors. Hooks: `ids-alert`, `ids-alert__title`, and `ids-alert__body`; tone is exposed as `data-tone`.

## ErrorSummaryComponent

Requires a localized `title:` and a non-empty list of `{field_id:, message:}` entries. It renders a focusable container, an alert region, and links to the invalid controls. For checkbox or radio groups, link to the first invalid native input rather than the fieldset. Messages must match the inline field errors. The page layer still owns adding an error prefix to the document title and moving focus to the summary after a failed submission.

```erb
<%= render Imagusu::DesignSystem::ErrorSummaryComponent.new(
  title: "There is a problem",
  errors: [
    { field_id: form.field_id(:email), message: "Enter a valid email" }
  ]
) %>
```

## CheckboxGroupComponent

Uses Rails `collection_check_boxes` inside `<fieldset><legend>`. It accepts `form:`, `method:`, `label:`, `label_suffix:`, `hint:`, `errors:`, `disabled:`, `options:`, `selected:`, `disabled_values:`, and `include_hidden:`. Option labels and values must be non-empty and generate unique Rails IDs. Explicit `selected:` must be an Array. Group-level `required` is rejected because applying native `required` to every checkbox means “select every option”, not “select at least one”; enforce group rules server-side and render the returned error.

## FileUploadComponent

Uses Rails `file_field` and the standard field anatomy. It supports `multiple:`, plus `accept`, `capture`, `autofocus`, `form`, `data`, and non-owned `aria` attributes. The component does not add drag-and-drop, previews, direct-upload JavaScript, file validation, or storage policy. File type and size must be validated server-side.

## BadgeComponent

Renders a non-interactive `<span>`. Tones are `neutral`, `accent`, `info`, `success`, `warning`, and `danger`, exposed through `data-tone`. A badge conveys short status or metadata; it is not a button or link and must not be the only place where critical information appears.

## CardComponent

Renders a neutral `<div>` by default and supports `as: :article`, `:section`, or `:li` when the surrounding document requires those semantics. It provides `header`, body content, and `footer` slots with `ids-card__header`, `ids-card__body`, and `ids-card__footer` hooks. If a section or article needs an accessible name, connect its heading with `aria-labelledby`.

## Public boundary

Component Ruby APIs, DOM order, `ids-*` classes, owned ARIA relationships, and `data-tone` values are public experimental contracts. Breaking changes require a minor release before 1.0. Visual tokens and styles will be layered on these hooks later.
