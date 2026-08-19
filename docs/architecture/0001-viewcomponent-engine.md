# ADR 0001: ViewComponent 4 with a Rails Engine

Status: superseded by ADR 0006

## Decision

Use ViewComponent 4 as the renderer and a lightweight, unmounted Rails Engine for discovery of packaged components. Support Ruby 3.3+ and Rails 8.0–8.1 while those combinations remain in CI.

## Consequences

Consumers use conventional Rails rendering and ERB. The gem has no routes, controllers, models, or database. Phlex and custom rendering abstractions are outside the 0.x scope.
