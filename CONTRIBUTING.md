# Contributing

## Before implementation

Open an issue describing the product use case. A new public component or state needs:

- a confirmed consumer and owner;
- a semantic HTML and accessibility contract;
- gallery states for every public state that benefits from visual inspection;
- rendered-output tests and manual keyboard checks;
- documentation and changelog entry.

Do not add framework-specific CSS utilities, runtime JavaScript, or new dependencies without an architecture decision record.

IDS-owned system text uses Rails I18n under `imagusu_design_system.*`. Product labels, hints, errors, actions, and other domain copy remain explicit consumer input. See `docs/architecture/0005-localization.md`.

## Local checks

```sh
bin/setup
bundle exec rake
```

The default task runs the architecture policy gate, tests, lint, and packaged-gem smoke verification. See `docs/quality/automated-controls.md` for active and planned evidence.

Keep commits focused. Add user-visible changes to `CHANGELOG.md`. Breaking changes before 1.0 require a minor version and migration notes.
