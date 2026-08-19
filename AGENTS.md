# IDS Agent Team

Instructions for agents working on Imagusu Design System (IDS).

## Mission

Build a small, Rails-native, skin-agnostic design-system foundation. IDS owns semantic HTML, accessibility contracts, stable rendering APIs, progressive enhancement, tests, and the boundary where an optional skin supplies tokens and visual styles.

Use Rails and browser primitives directly. Add an abstraction or dependency only when a demonstrated need cannot be met clearly without it.

## Hard boundaries

- Work only from this repository, its documented contracts, official Rails documentation, and cited public primary sources.
- Never read, compare, import, adapt, or copy anything from `/Users/damirsalakhov/imagusu`.
- Do not infer what DHH or 37signals would approve. Separate published guidance, observed public code, IDS decisions, and inference.
- Do not add a component framework, internal rendering DSL, slots framework, build step, or runtime dependency without a superseding architecture decision and measured justification.
- Core must remain useful without CSS or JavaScript. The first CSS may only implement ADR 0008 as one explicit opt-in, namespaced, plain-CSS skin and requires all-five review plus narrow policy/package changes in the same slice. JavaScript still requires a separate architecture decision and concrete consumer need.
- ViewComponent, Lookbook, `app/components/**`, a component base class, and compatibility renderers are prohibited by ADR 0006. Public rendering uses namespaced strict-local partials under `app/views/imagusu/design_system/`.

## Ownership model

The primary agent owns implementation and the final decision. Review agents are read-only unless the user explicitly assigns implementation to one of them. This prevents overlapping edits and keeps each review independent.

Five roles guard material work:

1. [Rails Architecture and API Steward](agents/roles/rails_architecture.md)
2. [Simplicity and Dependency Editor](agents/roles/simplicity.md)
3. [Accessibility and Inclusive Design Auditor](agents/roles/accessibility.md)
4. [Performance and Browser Platform Reviewer](agents/roles/performance.md)
5. [37signals Philosophy and Evidence Checker](agents/roles/37signals.md)

## Risk-based review

IDS is in private-consumer incubation. Use reviewers to challenge risky decisions, not as ceremony for every edit. The primary agent may make a small, reversible change when deterministic tests cover it and the public contract does not change.

All five roles review only:

- a renderer architecture, runtime dependency, build step, JavaScript, or frontend-boundary decision;
- a release that declares a component or skin stable.

Other work uses the smallest relevant set below. Documentation typos, test refactors that preserve coverage, gallery copy, and internal renames need no council review.

| Change | Required roles |
| --- | --- |
| New component or public state | Architecture, Accessibility; add Simplicity for a new abstraction and Performance for interaction, assets, or collection hot paths |
| Public API or Engine integration | Architecture; add the role whose contract changes |
| Other architecture decision | Architecture, 37signals; add the role whose boundary changes |
| HTML, form, ARIA, focus, or interaction | Accessibility; add Architecture when public markup or locals change |
| First skin/CSS, runtime dependency, build step, JavaScript, or frontend boundary | All five |
| Tests or gallery only | No review unless public coverage or behavior changes |
| EN/RU translation with unchanged meaning | Automated parity only; add Architecture and Accessibility if meaning or the public contract changes |
| Documentation | No review unless it changes a public contract or makes an evidence claim |
| Preview release | Architecture plus affected roles |
| Stable component or skin release | All five |

If scope grows into a mandatory category, stop and add the missing reviewers before continuing.

## Fast review sequence

Run reviews in parallel waves. Do not wait for one role before starting another role in the same wave.

### 1. Preflight

When the routing table requires preflight, run Architecture first and add 37signals only for an architecture, dependency, or philosophy claim. They confirm that the problem is real, the public boundary is small, Rails/browser primitives were considered first, and the direction is supported by evidence rather than imitation.

Add Accessibility to this preflight for a new or materially changed component, form, ARIA or focus contract, interaction, or skin contract. Accessibility defines acceptance criteria before the public interaction model is fixed, then reviews their implementation again in the diff wave.

### 2. Diff review

After a working diff exists, run only the roles selected by the routing table, in parallel. They review the changed contract and directly affected code.

### 3. Resolution

The primary agent resolves blockers, reruns relevant verification, and asks only affected reviewers to recheck.

### 4. Final gate

Architecture verifies a changed public API or compatibility boundary. The primary agent may complete the task when every routed role reports `PASS`, or `NOT_APPLICABLE` with a concrete reason.

## Shared review rules

Every reviewer must:

- stay within the assigned diff and contract;
- report facts with file-and-line evidence, a reproducible result, or a primary source;
- distinguish a blocker from a risk, improvement, or preference;
- propose the smallest correction that resolves each blocker;
- avoid unrelated refactors and future-proof options without a current consumer;
- state what was not reviewed;
- keep the response short enough to act on immediately.

No evidence or violated contract means no blocker.

## Verdict format

```text
VERDICT: PASS | CHANGES_REQUIRED | BLOCK | NOT_APPLICABLE
SCOPE: files, component, and states reviewed

BLOCKERS:
- [ROLE-01] file:line — fact and impact -> smallest correction

RISKS:
- maximum three non-blocking risks

EVIDENCE:
- tests, benchmark, manual result, or primary URL

COMPLEXITY DELTA:
- dependencies, public API, CSS bytes, JS bytes

NOT REVIEWED:
- explicit omissions
```

Omit empty items except `BLOCKERS`, which must say `none` for a passing review.

## Completion rule

For reviewed changes, the final report lists the routed role verdicts and verification run. Accessibility and performance claims must describe the actual evidence; installing IDS cannot by itself make a consuming application accessible or guarantee its Core Web Vitals.

Every user-facing completion report must include a verified clickable **View result** link:

- UI/component work — start and verify the local gallery or preview, then link its exact URL;
- documentation or code-only work — link the most relevant local file using its absolute path;
- published GitHub work — link the PR, commit, release, or Actions run;
- work with no renderable artifact — link the closest inspectable evidence and say plainly what cannot be viewed yet.

Do not invent a URL or link to a preview that is not running. When a requested preview cannot be started, state the blocker and link its source or instructions instead.

## Automation outranks review

An agent verdict never substitutes for a deterministic check. If a rule can be enforced reliably by a test, script, linter, package check, or CI assertion, add that control with the rule. A reviewer may interpret evidence and find gaps, but may not waive a failing automated gate.

Every completion report that makes a quality or compatibility claim must separate:

- automated checks that ran and passed;
- manual checks that were actually performed;
- planned checks that do not exist yet;
- behavior that cannot be proven automatically.

Do not describe a planned check, an agent inspection, or an automated accessibility scan as proof of complete correctness or accessibility.

## Component program

For component work, follow the ordered catalog and the repo-local [`ids-component-program`](.agents/skills/ids-component-program/SKILL.md) skill. The skill routes this policy; it does not supersede it. Component lifecycle, proportional tests, and completion marks live in:

- [`docs/components/catalog.md`](docs/components/catalog.md);
- [`docs/process/component-development.md`](docs/process/component-development.md);
- [`docs/quality/component-testing.md`](docs/quality/component-testing.md).
