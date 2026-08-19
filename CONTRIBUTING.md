# Contributing

## Before implementation

Open an issue describing the product use case. A new public component or state needs:

- a confirmed consumer and owner;
- a semantic HTML and accessibility contract;
- preview scenarios for every public state;
- rendered-output tests and manual keyboard checks;
- documentation and changelog entry.

Do not add framework-specific CSS utilities, runtime JavaScript, or new dependencies without an architecture decision record.

## Local checks

```sh
bin/setup
bundle exec rake
```

Keep commits focused. Add user-visible changes to `CHANGELOG.md`. Breaking changes before 1.0 require a minor version and migration notes.
