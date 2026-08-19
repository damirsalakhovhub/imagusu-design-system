# Component testing

IDS tests public behavior rather than implementation structure. The goal is enough deterministic evidence to change code safely without a cross-product test suite.

## Baseline for every public component

- default render: correct native root, required attributes, semantics, and public `ids-*` hooks;
- strict locals: a missing required local and an unknown local fail;
- every public option or state has one positive example, varied one axis at a time;
- invalid enum/boolean values and conflicting IDS-owned HTML/ARIA attributes fail;
- consumer text and attributes are escaped;
- IDS-owned accessible names, descriptions, errors, states, and relationships are asserted;
- one representative gallery state renders; the gallery does not duplicate the renderer suite.

Use ordinary `ActionView::TestCase` and integration tests. Do not add full-HTML snapshots, shared-example frameworks, a component test DSL, pairwise generators, or a browser runner before they solve a demonstrated gap.

## Category additions

| Category | Required when applicable | Triggered evidence |
| --- | --- | --- |
| Leaf | semantic root, text/name, hook, each variant and size independently | icon-only name/decorative icon; alternate link semantics; generated-ID uniqueness |
| Form | FormBuilder binding, label, nested ID/name/value, required/disabled, hint/error relationships | password value omission; checkbox/radio/select submission shape; multiple controls and generated IDs |
| Interactive | useful no-JavaScript baseline, keyboard path, focus entry/exit/restoration, ARIA/state synchronization, cancel path | overlay Escape/outside action; roving focus; async repeat/error/cancel; reduced motion |
| Composite | minimal plus one populated state, owned structure/order/relationships, real child composition | collections use 0/1/many; duplicate/nested ID checks; child interaction stays in the child's suite |
| Skin | core without skin, each variant at default size, each size at default variant, hooks/states, asset bytes | themes, responsive behavior, fonts, or motion only when introduced; stable adds text/non-text contrast, non-color state distinction, target size, visible/not-obscured focus, forced colors, zoom/reflow, and reduced motion where applicable |
| I18n | consumer Unicode text and owned EN/RU key parity | override and missing-key failure for owned strings; interpolation when used; pluralization only after a superseding rule decision and then with representative supported categories; RTL/long text for structure and skin |

## Combination rule

Do not test every Cartesian combination. Cover:

1. the default;
2. each axis changed independently;
3. each invalid boundary;
4. a combination only when template branching, selectors, ARIA, or browser behavior couples those axes;
5. 0/1/many only for collections.

If `4 variants × 3 sizes × 4 states` would create 48 cases, test four variants at the default size, three sizes at the default variant, and each state separately. Add a combined case only when the implementation makes the combination distinct.

## Commands and gates

- During work: run the changed test file, for example `bundle exec ruby -Itest test/views/imagusu/design_system/button_test.rb`.
- Before handoff: `bundle exec rake`.
- PR CI: policy, full rendered suite across supported Ruby/Rails, style, and package smoke. Repository security checks remain separate GitHub controls.
- Before a component becomes stable: installed-gem host proof, HTML validation, automated gallery accessibility scan, category-specific system tests, and applicable real-browser keyboard/assistive-technology evidence.
- Before a skin becomes stable: text/non-text contrast, non-color state distinction, target size, visible and unobscured focus, forced-colors, zoom/reflow, RTL/long-text, reduced-motion where applicable, and measured asset evidence.

The first component that requires browser-only interaction introduces the browser harness. The first official skin introduces skin checks. Running those empty systems for every earlier edit would add ceremony without evidence.
