# ADR 0007: Component program

Status: accepted

## Context

IDS needs a coherent component catalog without rebuilding a component framework or freezing speculative APIs. The project also needs enough planned coverage to grow into a useful design system, while implementing and proving one vertical slice at a time.

Button breadth is informed primarily by [Primer's current Button guidance](https://primer.style/product/components/button/) and checked against [RubyUI's Button documentation](https://www.rubyui.com/docs/button). These are references for use cases, terminology, and missing-state discovery. IDS does not depend on, copy, or reproduce either implementation.

## Decision

Maintain one ordered [component catalog](../components/catalog.md) with exactly one current family. Work starts with Button, then Text input, then Select. Move the current marker when the slices selected for that family's milestone are `preview` or deliberately deferred with a recorded dependency or reason. Deferred interaction must not block the next family, and `stable` maturation continues independently. A planned catalog entry is not public API and does not require speculative code.

Each component moves through four statuses:

- `planned` — problem and expected native semantics are recorded; no API promise;
- `preview` — documented strict-local API, implementation, gallery state, deterministic tests, and any owned EN/RU strings ship together; breaking changes are still expected;
- `stable` — the core contract has compatibility, applicable browser/keyboard/assistive-technology/localization, and routed five-role evidence; a skin has its own stable status and evidence;
- `deprecated` — replacement and migration path are documented.

Every component keeps semantic and presentation axes separate. Native HTML and behavior determine which public partial is used. Skin axes alter hooks and tokens, never the element's meaning.

The Button family is the first planned family. Its target visual axes are:

- variant: `secondary` by default, plus `primary`, `plain`, and `danger`;
- size: `medium` by default, plus `small` and `large`;
- width: `auto` by default or `full`.

The target family covers Button, LinkButton, IconButton, ButtonGroup, ToggleButton, MenuButton, and an asynchronous/loading button. These are separate semantic contracts rather than one polymorphic `as:` component. There is no public BaseButton. Shared private presentation code is introduced only after actual repetition makes it smaller than direct templates.

`danger` communicates visual emphasis; it does not imply confirmation. Confirmation is a separate interaction, normally owned by a consuming flow or a future Dialog contract. Toggle, menu, and asynchronous buttons do not ship until their state, keyboard, focus, announcement, failure, and no-JavaScript contracts are approved and tested. Icon buttons do not ship until IDS has a trusted icon composition and accessible-name contract.

The first Button milestone intentionally completed only the text native Button without a skin. The presentation axes later shipped together with the opt-in default skin at `preview`; related semantic components remain planned with their dependencies recorded in the catalog and Button contract. This preserves the family exit rule without publishing dormant locals or incomplete interaction.

Primer's full API is not a requirements list. IDS may omit an option that has no product-neutral use case, and may use a different Rails-native API. RubyUI remains a secondary simplicity reference, not a compatibility target.

## Delivery rule

For each catalog item:

1. record a short brief and explicit non-goals;
2. run Architecture and Accessibility preflight;
3. implement the smallest complete Rails-native vertical slice;
4. add proportional rendered, gallery, localization, package, and interaction evidence;
5. run only the reviewers selected by `AGENTS.md`;
6. update the catalog status and evidence links in the same change.

Deterministic checks outrank reviewer opinions. Reviewer gates are reserved for decisions requiring judgment; they are not a substitute for tests and are not run for documentation trivia.

## Consequences

IDS can plan broad coverage while keeping the current implementation small. Consumers can see what exists, what is next, and what is only planned. The Button family can become visually complete without turning navigation, toggles, menus, and asynchronous behavior into ambiguous flags on one renderer.
