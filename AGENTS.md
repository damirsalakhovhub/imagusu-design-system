# IDS Agent Team

Instructions for agents working on Imagusu Design System (IDS).

## Mission

Build a small, Rails-native, skin-agnostic design-system foundation. IDS owns semantic HTML, accessibility contracts, stable rendering APIs, progressive enhancement, tests, and the boundary where a separate skin supplies tokens and visual styles.

Use Rails and browser primitives directly. Add an abstraction or dependency only when a demonstrated need cannot be met clearly without it.

## Hard boundaries

- Work only from this repository, its documented contracts, official Rails documentation, and cited public primary sources.
- Never read, compare, import, adapt, or copy anything from `/Users/damirsalakhov/imagusu`.
- Do not infer what DHH or 37signals would approve. Separate published guidance, observed public code, IDS decisions, and inference.
- Do not add a component framework, internal rendering DSL, slots framework, build step, or runtime dependency without a superseding architecture decision and measured justification.
- Do not put product styling into the foundation. Core CSS is limited to behavior and accessibility that cannot safely be left to a skin.
- ViewComponent, Lookbook, `app/components/**`, a component base class, and compatibility renderers are prohibited by ADR 0006. Public rendering uses namespaced strict-local partials under `app/views/imagusu/design_system/`.

## Ownership model

The primary agent owns implementation and the final decision. Review agents are read-only unless the user explicitly assigns implementation to one of them. This prevents overlapping edits and keeps each review independent.

Five roles guard material work:

1. [Rails Architecture and API Steward](agents/roles/rails_architecture.md)
2. [Simplicity and Dependency Editor](agents/roles/simplicity.md)
3. [Accessibility and Inclusive Design Auditor](agents/roles/accessibility.md)
4. [Performance and Browser Platform Reviewer](agents/roles/performance.md)
5. [37signals Philosophy and Evidence Checker](agents/roles/37signals.md)

## Mandatory review

All five roles must review:

- a new or materially changed component;
- a public rendering API or skin contract;
- a dependency, build-tool, JavaScript, or asset-boundary change;
- a compatibility or architecture decision;
- a release containing any of the above.

Small changes use the routing table. A documentation typo with no contract effect needs no council review.

| Change | Required roles |
| --- | --- |
| New or changed component | All five |
| Public API, Engine integration, compatibility, release | All five |
| HTML, form, ARIA, focus, or interaction | All five for a public component; otherwise Architecture, Accessibility, Performance |
| Core CSS or skin contract | All five |
| Runtime dependency or build step | All five |
| Tests or gallery only | Architecture; add the role whose contract is exercised |
| Documentation of public behavior | Architecture, 37signals; add Accessibility for accessibility claims |

If scope grows into a mandatory category, stop and add the missing reviewers before continuing.

## Fast review sequence

Run reviews in parallel waves. Do not wait for one role before starting another role in the same wave.

### 1. Preflight

Before implementation, run Architecture and 37signals in parallel. They confirm that the problem is real, the public boundary is small, Rails/browser primitives were considered first, and the direction is supported by evidence rather than imitation.

Add Accessibility to this preflight for a new or materially changed component, form, ARIA or focus contract, interaction, or skin contract. Accessibility defines acceptance criteria before the public interaction model is fixed, then reviews their implementation again in the diff wave.

### 2. Diff review

After a working diff exists, run Simplicity, Accessibility, and Performance in parallel. They review only the changed contract and directly affected code.

### 3. Resolution

The primary agent resolves blockers, reruns relevant verification, and asks only affected reviewers to recheck.

### 4. Final gate

Architecture verifies the final public API and compatibility. The primary agent may complete the task only when every required role reports `PASS`, or `NOT_APPLICABLE` with a concrete reason.

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

For material changes, the final report must list the five role verdicts and the verification run. Accessibility and performance claims must describe the actual evidence; installing IDS cannot by itself make a consuming application accessible or guarantee its Core Web Vitals.

## Automation outranks review

An agent verdict never substitutes for a deterministic check. If a rule can be enforced reliably by a test, script, linter, package check, or CI assertion, add that control with the rule. A reviewer may interpret evidence and find gaps, but may not waive a failing automated gate.

Every material completion report must separate:

- automated checks that ran and passed;
- manual checks that were actually performed;
- planned checks that do not exist yet;
- behavior that cannot be proven automatically.

Do not describe a planned check, an agent inspection, or an automated accessibility scan as proof of complete correctness or accessibility.
