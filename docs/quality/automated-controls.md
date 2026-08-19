# Automated controls

Automated controls are the source of truth for mechanically verifiable IDS invariants. Agent review interprets evidence and finds missing coverage; it does not replace a test or waive a failure.

## Active controls

| Invariant | Command | CI | Limitation |
| --- | --- | --- | --- |
| No unapproved runtime gem, enumerated frontend manifest/build config, CSS/JavaScript, or new legacy component file | `ruby script/verify-policy` | `policy` job | The lists are finite and the script cannot protect a change that weakens itself; branch review must remain required |
| Rendered component behavior | `bundle exec rake test` | Compatibility matrix | Coverage is limited to written cases and the transitional renderer |
| Ruby style | `bundle exec rake standard` | Compatibility matrix | Style is not architectural correctness |
| Built gem installs and loads | `bundle exec rake package_smoke` | `package` job | Loading does not prove every packaged asset or locale works in a host |

`bundle exec rake` runs the active local gates together.

## Planned controls for the Rails-native renderer

These checks are requirements, not active coverage. Do not report them as passing until implemented.

| Area | Required deterministic evidence |
| --- | --- |
| Rendering API | Strict-locals failures for missing and unknown arguments; rendered-output tests for every public state |
| Localization | Default-key completeness, consumer overrides, missing-key failure, interpolation and pluralization, translated accessibility relationships |
| Direction and expansion | RTL and long-string pseudo-locales; no forced LTR direction; stable DOM and focus order |
| HTML and accessibility | HTML validation, relationship integrity, automated scanner for every gallery state |
| Keyboard behavior | System tests for focus entry, movement, restoration, Escape, submission, and error recovery |
| Skin boundary | Core works without a skin; official skin uses logical properties and passes contrast, forced-colors, zoom, and reflow checks |
| Performance | Reproducible render and allocation baseline; collection cases; raw and compressed CSS/JS budgets |
| Packaging | Installed host proves packaged views, helpers, locales, and assets are discoverable and overrideable |
| Compatibility | Supported Ruby and Rails matrix exercises the packaged gem, not only the repository checkout |

String and symbol literal IDS translation keys are checked today. Dynamically constructed keys require explicit tests and review because a static policy check cannot prove their namespace or completeness.

## Manual evidence

Some qualities cannot be established by scripts:

- translation accuracy, tone, and cultural suitability;
- screen-reader pronunciation and announcement timing;
- usability with magnification, voice control, switch access, and real user settings;
- usefulness of errors and instructions;
- disabled-user research for novel or high-impact patterns.

Release evidence records the browser, operating system, assistive technology, version, scenario, and result. Automated accessibility success is not certification of a component, skin, or consuming application.

## Adding a durable rule

When a new architecture, compatibility, accessibility, security, or performance rule is accepted:

1. add the smallest deterministic control that can enforce it;
2. add a negative test proving the control fails when violated;
3. wire the control into the default local task and CI;
4. document what remains manual or unprovable;
5. require an ADR change when weakening the control.
