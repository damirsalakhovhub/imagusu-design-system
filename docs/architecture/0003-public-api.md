# ADR 0003: Public API and versioning

Status: accepted

## Decision

Public API includes Ruby initializers, rendered semantics and DOM order, accepted attributes, component names, future CSS variables, assets, configuration, and generators. Before 1.0, breaking changes ship only in minor releases with migration notes. Patch releases remain backward compatible.

## Consequences

New options require a real consumer, tests, previews, accessibility notes, documentation, and ownership. Internal implementation detail is kept smaller than the documented contract.
