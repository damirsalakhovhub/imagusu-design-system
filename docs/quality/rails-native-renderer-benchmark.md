# Rails-native renderer benchmark

Date: 2026-08-19

Purpose: compare the transitional ViewComponent renderer with the Rails-native Button and TextField proof before deleting legacy code. This is migration evidence, not a permanent CI timing threshold or a general claim that ERB partials are faster.

## Environment

- proof commit: `032800e15e700c539c25840479ea9e32e6a8170f`;
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
| Button | legacy | 4.75 / 4.35 | 6.98 / 5.02 | 25 / 25 | 36 | 1 |
| Button | native | 16.50 / 15.41 | 17.40 / 16.65 | 62 / 62 | 55 | 1 |
| TextField, explicit error | legacy | 35.76 / 38.31 | 39.48 / 41.13 | 147 / 147 | 467 | 5 |
| TextField, explicit error | native | 39.11 / 39.77 | 43.00 / 44.12 | 146 / 146 | 462 | 5 |
| TextField, model error | legacy | 78.12 / 74.28 | 128.24 / 80.34 | 234.02 / 234.02 | 410 | 5 |
| TextField, model error | native | 79.95 / 80.28 | 84.07 / 83.81 | 234.02 / 234.02 | 405 | 5 |

The reverse-order pairs show low median and allocation noise. The first legacy model-error batch-average p95 contains visible runtime noise, so no individual-render latency improvement is claimed.

## Decision

Accept the measured Button regression for this migration:

- native p50 adds approximately 11–12 microseconds and 37 allocations per Button;
- the one-element DOM remains unchanged;
- the intentional `ids-button` skin hook accounts for the 19 extra HTML bytes;
- the native API adds strict-local enforcement, visible-text validation, owned-ARIA protection, and removes a runtime framework dependency and its public class/lifecycle surface.

At 1,000 Buttons the measured median batch delta is roughly 11–12 milliseconds; ordinary pages render far fewer. This is an explicit simplicity and dependency tradeoff, not a performance improvement. Revisit only with a representative consumer showing Button rendering is a hot path; do not add a helper facade or cache solely to improve this synthetic case.

TextField median batch averages differ by roughly 1–3 microseconds for explicit errors and 2–6 microseconds for model errors. Allocations and DOM nodes are equal or slightly lower in the native implementation. This small single-machine delta is accepted with the same dependency-removal rationale; no TextField speed improvement is claimed.

## Limits

- One machine and one Ruby/Rails pair do not establish a universal performance result.
- The benchmark measures warm server rendering, not network, browser, skin, interaction, or application Core Web Vitals.
- HTML bytes include intentional public hooks and ERB whitespace, not only renderer overhead.
- The benchmark script is removed with the legacy renderer after this evidence is captured; this document preserves the method and result.
