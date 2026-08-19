# Default skin delivery plan

Status: Button phase 1 implemented at preview; stable evidence pending

This plan implements [ADR 0008](../architecture/0008-optional-default-skin.md) one complete component slice at a time. The Button asset, modifier hooks, and four token names are public at `preview`; later entries remain plans rather than API.

## Fixed direction

- One official `default` skin in the existing gem.
- One explicit, namespaced, plain-CSS stylesheet; never auto-loaded.
- Core remains useful and tested without CSS.
- Initial brand customization is limited to `accent/on-accent` and `danger/on-danger` pairs.
- Neutral, focus, hover, active, shape, spacing, and typography decisions remain skin-owned.
- No JavaScript, build tool, external assets, generator, Ruby configuration, token compiler, or new runtime dependency. Propshaft is permitted only as the development/test host needed to prove the asset contract.
- Alternative official skins and additional semantic colours require a later demonstrated use case.

## Phase 1 — Button skin foundation

- [x] Record the Button skin brief: consumer case, visual states, proposed locals/hooks, token ownership, non-goals, and acceptance evidence.
- [x] Route all five preflight roles because the first CSS changes the frontend boundary.
- [x] Update the policy and package smoke to allow only the approved namespaced plain-CSS asset while continuing to reject JavaScript, preprocessors, manifests, build configuration, and other frontend files.
- [x] Add the opt-in default stylesheet and demonstrate that the gallery/core still renders without it.
- [x] Add Button presentation axes with their implementation, CSS, gallery, contract, and tests in the same vertical slices: variant first, then size, then width.
- [x] Cover `secondary` by default, plus `primary`, `plain`, and `danger`; `medium` by default, plus `small` and `large`; `auto` by default or `full`. Test one axis at a time rather than their Cartesian product.
- [x] Add only the four proposed brand variables after their default and override cases are present and accessibility evidence passes.
- [x] Keep system typography component-scoped and set only `font-family`, never global `body` typography or the `font` shorthand.
- [x] Prove an installed Rails 8 Propshaft host resolves the fingerprinted asset through its logical path. Claim Sprockets or pipeline-less support only after separate evidence.
- [x] Record one stylesheet request plus raw and gzip bytes as the initial performance baseline.
- [x] Add gallery states for default, each variant at the default size, each size at the default variant, disabled, focus-visible, long text, and brand override.
- [x] Add deterministic contrast checks for every official text/control state and token-override fixtures.
- [ ] Manually check keyboard focus, user text-spacing overrides, 200% text resize, 400% zoom/320px reflow, forced colours, RTL/long text, and coarse-pointer target size before `stable`.
- [x] Run all five diff roles; record automated, manual, planned, and unprovable evidence separately.

## Phase 2 — Form controls

- [ ] Apply the same default skin to TextField only after the Button asset boundary is proven.
- [ ] Preserve FormBuilder wrappers and target documented hooks rather than DOM ancestry.
- [ ] Cover default, required, disabled, readonly, hint, error, long text, RTL, zoom/reflow, focus, and forced-colours states.
- [ ] Reuse only already-public semantic tokens; add none merely for visual convenience.

## Later, only with a consumer

- [ ] Add `success/on-success` with the first shipped success component.
- [ ] Consider a second official skin only after its visual use case cannot be expressed as a small brand override.
- [ ] Consider an independent skin gem only when ownership, dependencies, or release cadence genuinely diverge from core.
- [ ] Consider runtime theme switching only with a product requirement; it is not part of the default skin.

## Exit for Button skin `preview`

- The public renderer, stylesheet, gallery, documentation, tests, package proof, and proposed token pairs ship together.
- Core without CSS remains functional.
- Loading the one documented stylesheet produces the official appearance without a host build step or JavaScript.
- Custom brand pairs are visibly supported but explicitly owned by the consumer.
- CSS byte evidence and known browser/accessibility limits are recorded.
