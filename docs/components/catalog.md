# Component catalog

This is the ordered, product-neutral IDS program. It is a working inventory, not a promise that every planned item will ship unchanged. Exactly one family is current. Its selected milestone slices reach `preview` or are explicitly deferred before the marker advances; stable maturation and deferred interaction may continue later.

## Status and marks

- `planned` — brief only; no public API;
- `preview` — code, contract, gallery, and deterministic evidence exist; API may change;
- `stable` — core compatibility and applicable release evidence complete; a skin is tracked independently;
- `deprecated` — replacement and migration path exist;
- ✅ complete; ◐ partly complete; ☐ not started; — not applicable yet.

## Program gates

| Area | State | Evidence |
| --- | --- | --- |
| Rails-native Engine and strict-local rendering | ✅ | [ADR 0006](../architecture/0006-rails-native-rendering.md) |
| Component lifecycle and ordered delivery | ✅ | [ADR 0007](../architecture/0007-component-program.md) |
| Proportional test strategy | ✅ | [Component testing](../quality/component-testing.md) |
| Risk-based subagent team | ✅ | [`AGENTS.md`](../../AGENTS.md) and [`agents/roles`](../../agents/roles) |
| Repo-local component workflow skill | ✅ | [`ids-component-program`](../../.agents/skills/ids-component-program/SKILL.md) |
| English/Russian owned-string parity | ✅ | [Localization ADR](../architecture/0005-localization.md) |
| Optional skin and brand-colour architecture | ✅ | [ADR 0008](../architecture/0008-optional-default-skin.md) |
| Official default skin and public tokens | ✅ | [Button skin contract](core-components.md) and [delivery plan](../plans/default-skin.md) |
| Browser/HTML/a11y release harness | ◐ | First-skin asset/contrast checks exist; HTML scanner and stable manual evidence remain planned |

## Ordered families

| # | Current | Family | Intended scope | State |
| ---: | :---: | --- | --- | --- |
| 1 |  | Button | Action, link-style action, icon, group, toggle, menu, loading | text Button milestone preview; remaining slices explicitly deferred |
| 2 | ▶ | Text input | Text-like inputs, labels, hints, errors, optional visual affordances | base TextField preview; family expansion planned |
| 3 |  | Select | Native single and multiple select; custom combobox is separate | planned |
| 4 |  | Textarea | Multiline text with the shared field contract | planned |
| 5 |  | Checkbox | Checkbox and CheckboxGroup | planned |
| 6 |  | Radio | Radio and RadioGroup | planned |
| 7 |  | Switch | Boolean setting with explicit state and label | planned |
| 8 |  | File input | Native upload control, help, errors, multiple-file state | planned |
| 9 |  | Date and time fields | Native-first date, time, datetime, month, and week inputs | planned |
| 10 |  | Form grouping | Fieldset, legend, grouped hint/error contract | planned |
| 11 |  | Error summary | Form-level errors and focus destination | planned |
| 12 |  | Link | Inline and standalone navigation semantics | planned |
| 13 |  | Alert and inline message | Informational, warning, success, and error feedback | planned |
| 14 |  | Badge and counter | Compact non-interactive status/count labels | planned |
| 15 |  | Progress and spinner | Determinate progress and carefully announced activity | planned |
| 16 |  | Details and accordion | Native disclosure first; grouped disclosure when justified | planned |
| 17 |  | Dialog | Modal/non-modal behavior, focus, dismissal, confirmation composition | planned |
| 18 |  | Tooltip | Supplemental text with pointer and keyboard parity | planned |
| 19 |  | Popover | Non-modal anchored content distinct from tooltip and menu | planned |
| 20 |  | Menu | MenuButton plus menu keyboard and focus behavior | planned with Button family; waits for behavior ADR |
| 21 |  | Combobox/autocomplete | Editable selection, filtering, announcements, fallback | planned |
| 22 |  | Tabs and segmented control | Content switching versus action selection kept distinct | planned |
| 23 |  | Breadcrumbs | Hierarchical navigation | planned |
| 24 |  | Pagination | Server-rendered page navigation | planned |
| 25 |  | Navigation list | Current-page and grouped navigation semantics | planned |
| 26 |  | Table | Native data table, caption, headers, responsive skin evidence | planned |
| 27 |  | Card | Presentational grouping; links/actions remain native children | planned |
| 28 |  | Empty state | Heading, explanation, and optional action composition | planned |
| 29 |  | Avatar | Image/fallback semantics and group treatment | planned |
| 30 |  | Toast/notification | Timed and persistent status behavior with announcement policy | planned |
| 31 |  | Skeleton | Non-semantic loading presentation with reduced-motion handling | planned |

Product shells such as application headers, sidebars, page layouts, and domain-specific pickers are patterns, not automatic core components. They enter the catalog only after a reusable consumer case is documented.

## Current component evidence

| Component | Brief/API | Core | Rendered tests | Gallery | Owned EN/RU | Skin | Stable evidence | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Button (text action) | ✅ | ✅ | ✅ | ✅ | — consumer label | ✅ default skin | ☐ | preview |
| Button visual variants/sizes/width | ✅ | ✅ | ✅ | ✅ | — | ✅ | ☐ | preview |
| LinkButton | ◐ needs skin/use case | ☐ | ☐ | ☐ | — consumer label | ☐ | ☐ | planned |
| IconButton | ◐ needs trusted icon | ☐ | ☐ | ☐ | ☐ where IDS owns a name | ☐ | ☐ | planned |
| ButtonGroup | ◐ needs grouping case | ☐ | ☐ | ☐ | — consumer label | ☐ | ☐ | planned |
| ToggleButton | ◐ needs no-JS state flow | ☐ | ☐ | ☐ | — consumer label | ☐ | ☐ | planned |
| MenuButton | ◐ needs behavior ADR | ☐ | ☐ | ☐ | — consumer label | ☐ | ☐ | planned |
| Async/loading Button | ◐ needs behavior ADR | ☐ | ☐ | ☐ | ☐ with its approved contract | ☐ | ☐ | planned |
| TextField (text-like input) | ✅ | ✅ | ✅ | ✅ | — consumer label/hint/errors | ☐ | ☐ | preview |

The next component work is the Text input state matrix and default-skin slice. Planned Button semantic extensions remain visible without becoming public API.
