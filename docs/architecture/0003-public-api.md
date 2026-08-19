# ADR 0003: Public API and versioning

Status: accepted

## Decision

Public API includes only contracts that IDS actually ships and documents: namespaced partial paths, strict locals, Rails FormBuilder integration, rendered semantics and DOM order, accepted attributes, class and state hooks, and IDS-owned translation keys when they exist. CSS variables, assets, configuration, and generators are not public API until a concrete consumer requires them and a later decision introduces them. Before 1.0, breaking changes ship only in minor releases with migration notes. Patch releases remain backward compatible.

## Consequences

New options require a real consumer, tests, gallery states where visual inspection is useful, accessibility notes, documentation, and ownership. Internal implementation detail is kept smaller than the documented contract.
