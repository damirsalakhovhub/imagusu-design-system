---
name: ids-component-program
description: Plan, build, change, or review an Imagusu Design System component through its ordered catalog, Rails-native contract, proportional tests, localization rules, and risk-based reviewer gates. Use for any new IDS component or public component state, component API change, gallery state, skin work, or component status decision.
---

# IDS component program

Build one complete vertical slice at a time. This skill orchestrates project rules; it does not replace them or invent a second component architecture.

## Start

1. Locate the repository root containing this skill and read `AGENTS.md`.
2. Read the current entry in `docs/components/catalog.md`.
3. Read `docs/process/component-development.md` and `docs/quality/component-testing.md`.
4. Read only the component contract and ADRs relevant to the change.
5. Respect the legacy-project exclusion in `AGENTS.md`; never inspect that repository.

## Plan

- Select the next ordered family unless a confirmed consumer need justifies a catalog change.
- Classify the work as leaf, form, interactive, composite, skin, and/or i18n.
- Record a short brief: use case, native HTML, strict locals/states, core/skin/consumer ownership, `ids-*` hooks, owned translations, non-goals, and acceptance evidence.
- Treat `planned` entries as inventory, not API.
- Route preflight and diff reviewers exactly through `AGENTS.md`. Do not convene all five roles for low-risk work.

## Implement

- Use namespaced strict-local Rails partials and Rails/browser primitives.
- Keep semantic components separate; do not create a polymorphic renderer or public base component.
- Add one option only with a current use case and one testable contract.
- English is canonical and Russian must ship for each IDS-owned key. Product text remains explicit consumer input.
- Add the proportional evidence selected by the component categories. Change one test axis at a time; do not generate a Cartesian matrix.
- Add CSS, JavaScript, a build step, or dependency only after the required superseding ADR and reviewer route.

## Finish

1. Run the changed test file during work and `bundle exec rake` before handoff.
2. Run package, browser, compatibility, or stable gates only when the documented trigger applies.
3. Resolve routed reviewer blockers; reviewer opinions never waive automation.
4. Update the catalog marks, status, contract, and evidence in the same change.
5. Report automated checks, manual checks, planned checks, and unprovable behavior separately.

Never mark a component `stable` because an agent says `PASS`. Stable status requires the contract's recorded release evidence and all five routed roles.
