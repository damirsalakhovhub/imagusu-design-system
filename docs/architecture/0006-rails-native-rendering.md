# ADR 0006: Rails-native rendering

Status: accepted

## Context

ADR 0001 selected ViewComponent before IDS had an external release or a proven consumer. As of 2026-08-19, GitHub has no IDS release or tag, RubyGems has no `imagusu_design_system` package, and the expanded component catalog is unreleased work. Preserving its class constructors, slots, preview framework, and renderer dependency would turn an experiment into a compatibility burden.

The existing tests contain useful semantic, form, escaping, and accessibility requirements. They are evidence to reinterpret through Rails primitives, not an implementation to port class by class.

## Decision

Replace the ViewComponent implementation with a Rails-native rendering surface.

The only public rendering API is ordinary Rails `render` of namespaced partials:

```erb
<%= render "imagusu/design_system/button",
  content: "Save",
  type: :submit,
  disabled: false,
  html_attributes: {} %>

<%= render "imagusu/design_system/text_field",
  form: form,
  method: :email,
  label: "Email",
  type: :email %>
```

Every public partial declares strict locals. Its namespaced path, locals, rendered semantics, DOM order, and documented `ids-*` hooks are versioned public API. Partials do not read controller instance variables, request state, or implicit consumer configuration.

Single-element output uses Rails tag helpers. Structured output uses ERB. A component may accept one ordinary content value or Rails block when a demonstrated composition need exists; IDS will not provide slots, builders, a component base class, lifecycle callbacks, or a rendering DSL.

Private helpers or plain Ruby objects may isolate validation or repeated relationship logic only when keeping that logic in a template is materially less clear. They do not form a second documented rendering API.

Form partials receive the consumer's ordinary Rails `FormBuilder`. Rails remains responsible for bound names, IDs, values, nested scopes, selected and checked state, and hidden submission inputs. IDS may add semantic wrappers, visible labels, hints, errors, relationships, and stable skin hooks without subclassing or globally replacing the builder.

The Rails Engine exists only to make packaged views, helpers, and locales discoverable. It adds no routes, controllers, models, global configuration, or host monkey patches. Core rendering does not depend on a skin, CSS, JavaScript, or a frontend build step.

The first rebuilt public surface contains only Button and TextField. Deferred components return only after a confirmed use case. IDS will not preserve the experimental `*Component.new` API or ship a compatibility adapter or hybrid renderer.

## Cutover rule

Legacy ViewComponent code may remain read-only on the rebuild branch only until native Button and TextField pass their rendered contracts, installed-package smoke test, plain gallery render, and comparative benchmark. No new legacy behavior may be added.

The cutover then removes all ViewComponent and Lookbook implementation, tests, previews, configuration, dependencies, and compatibility matrix entries together. The policy gate changes from a transitional allowlist to a prohibition.

## Consequences

IDS has one Rails-native rendering concept and one runtime dependency: `railties`. The cutover deliberately breaks an unpublished experimental API. Useful behavior is retained as renderer-neutral acceptance criteria; accidental constructor, slot, whitespace, and preview-class details are discarded.

Strict locals make missing and unknown arguments deterministic. Rails partial paths become public and therefore cannot be renamed casually. Performance is measured rather than inferred: removing ViewComponent is a dependency and simplicity decision, not an automatic speed claim.
