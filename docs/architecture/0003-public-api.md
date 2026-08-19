# ADR 0003: Public API and versioning

Status: accepted

## Decision

Public API includes namespaced partial paths, strict locals, Rails FormBuilder integration, rendered semantics and DOM order, accepted attributes, class and state hooks, translation keys, future CSS variables, assets, configuration, and generators. Before 1.0, breaking changes ship only in minor releases with migration notes. Patch releases remain backward compatible.

## Consequences

New options require a real consumer, tests, gallery states where visual inspection is useful, accessibility notes, documentation, and ownership. Internal implementation detail is kept smaller than the documented contract.
