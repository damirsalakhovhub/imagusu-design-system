# Rails-native renderer benchmark

Date: 2026-08-19

Purpose: compare the transitional ViewComponent renderer with the Rails-native Button and TextField proof before deleting legacy code. This is migration evidence, not a permanent CI timing threshold or a general claim that ERB partials are faster.

## Environment

- base commit: `30921e7434f88f402eeb9abfacf8584ff87675a5`, with the uncommitted Rails-native proof diff;
- Ruby 3.4.5 arm64, Rails 8.1.3.1, ViewComponent 4.12.0;
- Mac16,5 on macOS Darwin 24 arm64, 16 reported processors;
- AC power, battery charged, with no intentional throttling;
- all Action View resolvers verified with template caching enabled;
- 200 warm-up renders and 40 measured samples;
- batches: 1,000 Buttons and 200 TextFields;
- the complete sequence ran legacy/native and then native/legacy;
- time uses `Process::CLOCK_MONOTONIC`; allocations use `GC.stat(:total_allocated_objects)`.

Reproduce while legacy still exists:

```sh
bundle exec script/benchmark-renderers
```

## Results

Each timing sample is one batch average normalized per render. The table reports percentiles across 40 normalized batch averages, not percentiles of individual renders or tail latency. Each cell shows the two order runs.

| Scenario | Renderer | p50 µs | p95 µs | Allocations | HTML bytes | Elements |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| Button | legacy | 4.65 / 4.63 | 7.24 / 5.15 | 25 / 25 | 36 | 1 |
| Button | native | 15.47 / 15.85 | 17.08 / 16.89 | 62 / 62 | 55 | 1 |
| TextField, explicit error | legacy | 37.06 / 39.42 | 48.21 / 42.03 | 147 / 147 | 467 | 5 |
| TextField, explicit error | native | 42.16 / 42.63 | 45.72 / 45.18 | 146 / 146 | 462 | 5 |
| TextField, model error | legacy | 79.57 / 76.33 | 133.19 / 80.88 | 234.02 / 234.02 | 410 | 5 |
| TextField, model error | native | 76.19 / 77.64 | 83.43 / 84.15 | 234.02 / 234.02 | 405 | 5 |

The reverse-order pairs show low median and allocation noise. The first legacy model-error batch-average p95 contains visible runtime noise, so no individual-render latency improvement is claimed.

## Decision

Accept the measured Button regression for this migration:

- native p50 adds approximately 11 microseconds and 37 allocations per Button;
- the one-element DOM remains unchanged;
- the intentional `ids-button` skin hook accounts for the 19 extra HTML bytes;
- the native API adds strict-local enforcement, visible-text validation, owned-ARIA protection, and removes a runtime framework dependency and its public class/lifecycle surface.

At 1,000 Buttons the measured p50 delta is roughly 11 milliseconds; ordinary pages render far fewer. This is an explicit simplicity and dependency tradeoff, not a performance improvement. Revisit only with a representative consumer showing Button rendering is a hot path; do not add a helper facade or cache solely to improve this synthetic case.

TextField p50 differs by roughly 3–5 microseconds for explicit errors and remains within cross-order noise for model errors. Allocations and DOM nodes are equal or slightly lower in the native implementation. No material TextField regression is accepted or claimed.

## Limits

- One machine and one Ruby/Rails pair do not establish a universal performance result.
- The benchmark measures warm server rendering, not network, browser, skin, interaction, or application Core Web Vitals.
- HTML bytes include intentional public hooks and ERB whitespace, not only renderer overhead.
- The benchmark script is removed with the legacy renderer after this evidence is captured; this document preserves the method and result.
