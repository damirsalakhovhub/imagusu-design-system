# ADR 0002: Frontend boundary

Status: superseded by [ADR 0008](0008-optional-default-skin.md) for CSS; JavaScript decision remains active

## Decision

Version 0.1 ships no CSS or JavaScript. Components expose namespaced `ids-*` class hooks and `data-state` tokens as public styling contracts. Future CSS must be browser-ready, namespaced, and independent of the consumer's Propshaft, Sprockets, Tailwind, or bundler choice. Runtime JavaScript requires a separate explicit decision.

## Consequences

Installing or removing the gem is a Gemfile-only operation. Visual tokens and behavior can evolve without making a host build tool part of the runtime API.
