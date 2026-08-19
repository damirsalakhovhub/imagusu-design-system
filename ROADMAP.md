# Roadmap

## Foundation — current

- Rails-native Engine packaging with `railties` as the only runtime dependency.
- Strict-local Button and TextField partials proving leaf and FormBuilder-bound rendering.
- Ordered component catalog and lightweight component-development workflow.
- Deterministic architecture, package, compatibility, rendered-contract, and EN/RU parity gates.
- Gallery explicitly loading the one shipped default skin through Propshaft, with no JavaScript.
- Preview Button skin with secondary, primary, plain, danger, size/width axes, and paired brand colours.
- Complete the planned HTML validation and automated accessibility controls.
- Record manual keyboard and assistive-technology evidence before describing either component as stable.

## Alpha

- Expand the current Text input family, then implement Select, following the catalog state matrix.
- Apply the proven default-skin boundary to TextField, then Select, through the ordered [skin plan](docs/plans/default-skin.md).
- Return to deferred Button icon, grouping, and interaction slices only when their semantic or behavior dependencies are approved.
- Add a component only after documenting its consumer problem, semantic contract, accessibility evidence, and skin boundary.

## 1.0

- Stable rendering paths, strict locals, markup, localization, token, and asset contracts.
- Documented support window, deprecation policy, and migration guides.
- Accessibility evidence covering automated, keyboard, zoom/reflow, forced-colors, and assistive-technology scenarios.
