# Roadmap

## Foundation — current

- Rails-native Engine packaging with `railties` as the only runtime dependency.
- Strict-local Button and TextField partials proving leaf and FormBuilder-bound rendering.
- Ordered component catalog and lightweight component-development workflow.
- Deterministic architecture, package, compatibility, rendered-contract, and EN/RU parity gates.
- Plain gallery with preview-local font/favicon styling and no shipped skin or JavaScript.
- Accepted optional default-skin and small brand-colour direction; implementation remains planned.
- Complete the planned HTML validation and automated accessibility controls.
- Record manual keyboard and assistive-technology evidence before describing either component as stable.

## Alpha

- Expand the current Text input family, then implement Select, following the catalog state matrix.
- Deliver the opt-in default Button skin through the ordered [skin plan](docs/plans/default-skin.md), then return to deferred icon, grouping, and interaction slices when their own dependencies are approved.
- Introduce proposed brand tokens only with the CSS, consumer evidence, and tests that make them real public API.
- Add a component only after documenting its consumer problem, semantic contract, accessibility evidence, and skin boundary.

## 1.0

- Stable rendering paths, strict locals, markup, localization, token, and asset contracts.
- Documented support window, deprecation policy, and migration guides.
- Accessibility evidence covering automated, keyboard, zoom/reflow, forced-colors, and assistive-technology scenarios.
