# Imagusu Design System

Server-rendered UI components for Imagusu applications built with Ruby on Rails.

The project is an early-stage Rails adapter for the Imagusu Design System. Version 0.1 proves the packaging, component API, compatibility, accessibility, and release workflow before the visual language is added.

## Status

Experimental. Public APIs can change in minor releases before 1.0. Patch releases remain backward compatible.

Supported runtime:

- Ruby 3.3, 3.4, or 4.0;
- Rails 8.0 or 8.1;
- ViewComponent 4.x.

CI tests every Ruby/Rails pair in this range and the minimum supported ViewComponent 4.0 release.

## Installation

Until the first RubyGems release, install from GitHub:

```ruby
gem "imagusu_design_system",
  github: "damirsalakhovhub/imagusu-design-system"
```

Then run `bundle install`. The Rails engine loads components automatically. The gem does not modify the host application and includes no CSS or JavaScript in 0.1.

## Usage

```erb
<%= render Imagusu::DesignSystem::ButtonComponent.new do %>
  Save
<% end %>
```

```erb
<%= render Imagusu::DesignSystem::ButtonComponent.new(
  type: :submit,
  disabled: form_disabled,
  html_attributes: {
    form: "profile-form",
    data: { action: "profile#save" },
    aria: { label: "Save profile" }
  }
) do %>
  Save
<% end %>
```

`type` accepts `:button`, `:submit`, or `:reset`. Supported HTML attributes are `id`, `name`, `value`, `form`, `title`, `autofocus`, `data`, and `aria`. Content and attributes are escaped by Rails.

Consumers own the accessible name and page-level behavior. Automated component tests do not replace keyboard and assistive-technology testing in the consuming application.

## Development

```sh
bin/setup
bundle exec rake
```

The default task runs component tests, Standard Ruby, and a packaged-gem smoke test. Compatibility appraisals:

```sh
bundle exec appraisal rails-8-0 rake
bundle exec appraisal rails-8-1 rake
bundle exec appraisal rails-8-0-view-component-4-0 rake
```

See [CONTRIBUTING.md](CONTRIBUTING.md), [ROADMAP.md](ROADMAP.md), and [docs/architecture](docs/architecture) before adding a component.

## Release policy

Releases use Semantic Versioning. Before 1.0, breaking API or markup changes require a minor release and migration notes; patches are backward compatible. RubyGems publication uses Trusted Publishing with GitHub OIDC and no long-lived API token.

## License

MIT License. See [LICENSE.txt](LICENSE.txt).
