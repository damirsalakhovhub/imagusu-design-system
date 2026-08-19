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
5. For any skin or brand-theme work, read `docs/architecture/0008-optional-default-skin.md` and `docs/plans/default-skin.md`.
6. Respect the legacy-project exclusion in `AGENTS.md`; never inspect that repository.

## Plan

- Select the next ordered family unless a confirmed consumer need justifies a catalog change.
- Classify the work as leaf, form, interactive, composite, skin, and/or i18n.
- Record a short brief: use case, native HTML, strict locals/states, core/skin/consumer ownership, `ids-*` hooks, owned translations, non-goals, and acceptance evidence.
- Treat `planned` entries as inventory, not API.
- For skin work, distinguish the component skin from its small brand-colour theme. Record the no-skin control, one opt-in asset, paired semantic colour inputs, package proof, byte evidence, and accessibility ownership.
- Route preflight and diff reviewers exactly through `AGENTS.md`. Do not convene all five roles for low-risk work.

## Implement

- Use namespaced strict-local Rails partials and Rails/browser primitives.
- Keep semantic components separate; do not create a polymorphic renderer or public base component.
- Add one option only with a current use case and one testable contract.
- English is canonical and Russian must ship for each IDS-owned key. Product text remains explicit consumer input.
- Add the proportional evidence selected by the component categories. Change one test axis at a time; do not generate a Cartesian matrix.
- Add CSS, JavaScript, a build step, or dependency only after the required superseding ADR and reviewer route.

## Skin work

- Implement only the accepted default skin until a real second visual case exists.
- Keep it in the current gem as one self-contained, namespaced, browser-ready CSS asset that the host explicitly links. Never auto-load it.
- Core behavior and rendered tests must continue to work without the stylesheet.
- Add no Sass, npm, build step, JavaScript, external asset, generator, Ruby theme configuration, token registry, or new runtime dependency. Propshaft is the only permitted development/test addition for proving the first skin in an installed host; remove that exception if the proof no longer needs it.
- Expose only paired semantic foreground/background colours consumed by the current component. Initial proposed token names remain non-API until their CSS, tests, docs, and package evidence ship together.
- Keep neutral, focus, interaction-state, spacing, radius, and typography values private until a consumer requires control. Apply a system font with `font-family`, not the `font` shorthand.
- Target documented `.ids-*`, native state, and `data-state` hooks without global resets, host element rules, undocumented ancestry, or `!important`.
- Treat arbitrary brand overrides as consumer-owned themes. Validate bundled defaults and derived states; never claim arbitrary consumer colours are accessible.
- Load exactly one official skin. Do not build a registry or compatibility promise for future skins.

## Finish

1. Run the changed test file during work and `bundle exec rake` before handoff.
2. Run package, browser, compatibility, or stable gates only when the documented trigger applies.
3. For a skin preview, prove the no-skin path, installed-host asset discovery, token-pair override, one CSS request with no JavaScript, and raw/gzip baseline. Reserve the full manual browser/accessibility matrix for `stable` as documented.
4. Resolve routed reviewer blockers; reviewer opinions never waive automation.
5. Update the catalog marks, status, contract, and evidence in the same change.
6. Report automated checks, manual checks, planned checks, and unprovable behavior separately.
7. Include the verified **View result** link required by `AGENTS.md`; start the gallery for UI work instead of returning a dead local URL.

Never mark a component `stable` because an agent says `PASS`. Stable status requires the contract's recorded release evidence and all five routed roles.
