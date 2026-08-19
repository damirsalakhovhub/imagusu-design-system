# ADR 0003: Public API and versioning

Status: accepted

## Decision

Public API includes only contracts that IDS actually ships and documents: namespaced partial paths, strict locals, Rails FormBuilder integration, rendered semantics and DOM order, accepted attributes, class and state hooks, and IDS-owned translation keys when they exist. A `planned` catalog entry is inventory, not public API. CSS variables, assets, configuration, and generators are not public API until a concrete consumer requires them and a later decision introduces them. An accepted direction or proposed token name is still non-API until its implementation, documentation, tests, and package evidence ship together. Before 1.0, breaking changes ship only in minor releases with migration notes. Patch releases remain backward compatible.

The Button skin makes one asset path and four colour properties public: `imagusu_design_system/skins/default`, `--ids-color-accent`, `--ids-color-on-accent`, `--ids-color-danger`, and `--ids-color-on-danger`. Button modifier classes documented with its strict locals are also public hooks. Neutral colours and all other skin custom properties remain private.

## Consequences

New options require a real consumer, tests, gallery states where visual inspection is useful, accessibility notes, documentation, and ownership. Internal implementation detail is kept smaller than the documented contract.
