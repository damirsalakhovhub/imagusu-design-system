# Roadmap

## Foundation — current

- Rails-native Engine packaging with `railties` as the only runtime dependency.
- Strict-local Button and TextField partials proving leaf and FormBuilder-bound rendering.
- Deterministic architecture, package, compatibility, and rendered-contract gates. Translation namespace checks are active; full localization evidence starts with the first IDS-owned string.
- Plain no-CSS/no-JavaScript gallery.
- Complete the planned HTML validation and automated accessibility controls.
- Record manual keyboard and assistive-technology evidence before describing either component as stable.

## Alpha

- Pilot Button and TextField in confirmed consumer flows and remove unnecessary options.
- Define skin tokens and browser-ready namespaced CSS without a consumer build step.
- Add a component only after documenting its consumer problem, semantic contract, accessibility evidence, and skin boundary.

## 1.0

- Stable rendering paths, strict locals, markup, localization, token, and asset contracts.
- Documented support window, deprecation policy, and migration guides.
- Accessibility evidence covering automated, keyboard, zoom/reflow, forced-colors, and assistive-technology scenarios.
