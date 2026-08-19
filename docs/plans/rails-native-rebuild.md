# Rails-native rebuild plan

Status: approved on 2026-08-19

This plan executes ADR 0006. Five independent roles reached consensus: Rails architecture, simplicity, accessibility, performance, and 37signals evidence review.

## Facts and baseline

- GitHub has no IDS releases or tags; RubyGems has no published `imagusu_design_system` package.
- The repository has no known external compatibility obligation. If evidence of a consumer appears, pause and revise the ADR rather than silently adding a shim.
- The pre-rebuild deterministic baseline is `105 runs, 311 assertions, 0 failures`, plus Standard, policy, and package-smoke success.
- Current runtime dependencies are `railties` and `view_component`; target runtime dependencies are `railties` only.
- Core CSS, JavaScript, and frontend build tooling remain zero.

## Product scope after cutover

Public and implemented:

- Button — native button semantics, visible content, type and disabled state, safe consumer attributes, stable skin hook.
- TextField — ordinary Rails FormBuilder binding, visible label, optional hint and errors, native required/disabled state, stable semantic relationships and skin hooks.

Not public after cutover:

- Alert, Badge, Card, Checkbox, CheckboxGroup, ErrorSummary, Field, FileUpload, Link, RadioGroup, Select, and TextArea.

These names are a requirements backlog, not promised components. They return only for a documented consumer case.

## Renderer-neutral requirements retained from the experiment

For every rebuilt form control:

- use its native HTML element before ARIA;
- require a nonblank visible label and preserve a matching `label[for]` and control ID;
- let Rails own bound names, IDs, values, nested indexes, selected/checked states, and hidden submission inputs;
- never echo a password value;
- render hint and error IDs exactly once and merge/deduplicate them with consumer `aria-describedby` tokens;
- set `aria-invalid="true"` only when an error is rendered;
- preserve native `required`, `disabled`, and `multiple` behavior where applicable;
- keep option IDs unique and associate every radio or checkbox with its label;
- escape consumer text and attributes and reject overrides of IDS-owned names, states, relationships, and hooks.

For feedback and grouping components if they return:

- static alerts have no live-region role; announcements require explicit dynamic intent;
- groups use `fieldset` and a visible `legend` when that is the native semantic model;
- an error summary is focusable, has an accessible name, and links to real invalid native controls;
- core output remains useful without CSS or JavaScript.

Tests assert semantics, relationships, submission behavior, and public hooks. They do not preserve insignificant whitespace, ViewComponent constructors, inheritance, slots, or preview classes.

## Execution

### 1. Record the decision

- Supersede ADR 0001 with ADR 0006.
- Keep this plan as the single migration checklist.
- Do not add a migration shim or a second public rendering API.

Exit: Architecture, Accessibility, and 37signals preflight agree on the API and cutover. **Complete.**

### 2. Prove the native vertical slices

- Add public strict-local partials for Button and TextField under `app/views/imagusu/design_system/`.
- Use ordinary Rails tag and FormBuilder helpers; add private helper code only for demonstrated validation or relationship complexity.
- Add renderer-neutral Action View tests, including missing/unknown locals, escaping, invalid input, nested form binding, hint/error relationships, and no accidental live-region or accessible-name override.
- Add a plain dummy-app gallery route and view for every public state of these two components. The gallery is for inspection, not a duplicate assertion suite.
- Update package smoke to install the gem and render both partials from the installed package.

Exit: native tests, gallery test, and installed-package smoke pass while legacy remains unchanged and read-only.

### 3. Measure before deletion

- Add a standard-library benchmark script; no benchmark gem and no timing threshold in shared CI.
- On one commit, render equivalent legacy and native Button/TextField states with the same view context and template caching.
- Record commit, Ruby/Rails/ViewComponent versions, platform, hardware and power condition, warm-up, sample count, run order, p50/p95 of normalized batch averages, allocations, HTML bytes, and DOM nodes. Batch percentiles are not individual-render tail latency.
- Minimum method: 200 warm-ups; 40 timed samples; batches of 1,000 Buttons and 200 TextFields; run legacy/native and native/legacy.
- Investigate a repeatable regression outside measured A/A noise. Accept a regression only with a recorded numeric delta and correctness or simplicity reason.

Exit: evidence is stored without claiming that ERB partials are inherently faster.

### 4. Atomic cutover

Delete:

- `app/components/**` and `test/components/**`;
- ViewComponent from the gemspec, require path, Appraisals, generated gemfiles, tests, and CI/release matrices;
- Lookbook from the Gemfile, dummy application, routes, previews, and documentation;
- the transitional ViewComponent file allowlist.

Keep and adapt:

- Rails Engine, package layout, Ruby/Rails compatibility matrix, release workflow, policy verifier, dummy app, `bin/components`, and package smoke;
- architecture, accessibility, localization, security, contribution, and automation contracts.

Also:

- make the policy gate reject `view_component`, `lookbook`, and every new `app/components/**` file;
- remove all advertised deferred components and obsolete examples from README, roadmap, changelog, and component docs;
- correct the changelog's false released-`0.1.0` history while retaining release automation for the first real publication;
- regenerate dependency lockfiles that are committed or used by CI.

Exit: `rg` finds ViewComponent or Lookbook only in historical ADR/migration evidence; runtime dependency is exactly `railties`; repository and built gem contain no `app/components`, CSS, JavaScript, or frontend manifests.

### 5. Final deterministic gate

- `bundle exec rake` passes policy, tests, Standard, and installed-package smoke.
- Rails 8.0/8.1 across Ruby 3.3/3.4/4.0 pass in GitHub Actions.
- Built-gem inspection proves views and required Ruby files are packaged and legacy files are absent.
- Every public gallery state passes HTML validation and automated accessibility scanning once those controls are installed.
- Manual keyboard and assistive-technology results are recorded separately before calling the components stable.

Exit: all five roles report `PASS`. Planned browser/AT evidence is never reported as completed automation.

## Explicit non-goals

- recreating ViewComponent with an IDS base class, slots DSL, lifecycle, or helper facade;
- restoring the entire experimental catalog;
- adding a FormBuilder subclass, global configuration, JavaScript, CSS, npm, or a build step;
- claiming DHH or 37signals endorsement;
- claiming application-wide accessibility or performance from isolated component checks.
