# frozen_string_literal: true

require "pathname"
require "rubygems"

module IDS
  class PolicyVerifier
    ALLOWED_RUNTIME_DEPENDENCIES = %w[railties view_component].freeze
    REQUIRED_RUNTIME_DEPENDENCIES = %w[railties].freeze
    FRONTEND_MANIFESTS = %w[
      package.json
      package-lock.json
      yarn.lock
      pnpm-lock.yaml
      bun.lock
      bun.lockb
    ].freeze
    FRONTEND_CONFIG_GLOBS = %w[
      esbuild.config.*
      postcss.config.*
      tailwind.config.*
      vite.config.*
      webpack.config.*
    ].freeze
    SHIPPED_FRONTEND_GLOBS = %w[
      app/**/*.{css,less,sass,scss}
      app/**/*.{cjs,js,jsx,mjs,ts,tsx}
    ].freeze
    I18N_KEY_PATTERNS = [
      /I18n\.(?:t|translate)\s*(?:\(\s*|\s+)["']([^"']+)/,
      /(?<![\w.])(?:t|translate)\s*(?:\(\s*|\s+)["']([^"']+)/
    ].freeze
    I18N_SYMBOL_KEY_PATTERNS = [
      /I18n\.(?:t|translate)\s*(?:\(\s*|\s+):(?:["']([^"']+)["']|([a-zA-Z_]\w*))/, # qualified call
      /(?<![\w.])(?:t|translate)\s*(?:\(\s*|\s+):(?:["']([^"']+)["']|([a-zA-Z_]\w*))/
    ].freeze
    I18N_NAMESPACE = "imagusu_design_system."

    def initialize(root)
      @root = Pathname(root).expand_path
    end

    def errors
      @errors ||= [].tap do |errors|
        verify_runtime_dependencies(errors)
        verify_frontend_boundary(errors)
        verify_legacy_component_freeze(errors)
        verify_i18n_namespace(errors)
      end
    end

    def run(output: $stdout)
      if errors.empty?
        output.puts "Policy verification passed"
        true
      else
        output.puts "Policy verification failed:"
        errors.each { |error| output.puts "- #{error}" }
        false
      end
    end

    private

    def verify_runtime_dependencies(errors)
      gemspec = @root.join("imagusu_design_system.gemspec")
      unless gemspec.file?
        errors << "imagusu_design_system.gemspec is missing"
        return
      end

      specification = Gem::Specification.load(gemspec.to_s)
      unless specification
        errors << "imagusu_design_system.gemspec could not be loaded"
        return
      end

      dependencies = specification.runtime_dependencies.map(&:name).uniq.sort
      unexpected = dependencies - ALLOWED_RUNTIME_DEPENDENCIES
      missing = REQUIRED_RUNTIME_DEPENDENCIES - dependencies

      errors << "unapproved runtime dependencies: #{unexpected.join(", ")}" if unexpected.any?
      errors << "required runtime dependencies missing: #{missing.join(", ")}" if missing.any?
    end

    def verify_frontend_boundary(errors)
      manifests = FRONTEND_MANIFESTS.filter { |path| @root.join(path).exist? }
      configs = FRONTEND_CONFIG_GLOBS.flat_map { |glob| relative_files(glob) }.uniq.sort
      shipped_frontend = SHIPPED_FRONTEND_GLOBS.flat_map { |glob| relative_files(glob) }.uniq.sort

      errors << "unapproved frontend manifests: #{manifests.join(", ")}" if manifests.any?
      errors << "unapproved frontend build configuration: #{configs.join(", ")}" if configs.any?
      if shipped_frontend.any?
        errors << "frontend files cannot ship before an architecture decision: #{shipped_frontend.join(", ")}"
      end
    end

    def verify_legacy_component_freeze(errors)
      allowlist_path = @root.join("script/policy/view_component_files.txt")
      unless allowlist_path.file?
        errors << "script/policy/view_component_files.txt is missing"
        return
      end

      allowed = allowlist_path.readlines(chomp: true).reject { |line| line.empty? || line.start_with?("#") }
      current = relative_files("app/components/**/*")
      unexpected = current - allowed

      if unexpected.any?
        errors << "new legacy component files are forbidden during migration: #{unexpected.join(", ")}"
      end
    end

    def verify_i18n_namespace(errors)
      relative_files("{app,lib}/**/*.{erb,rb}").each do |path|
        contents = @root.join(path).read
        keys = (I18N_KEY_PATTERNS + I18N_SYMBOL_KEY_PATTERNS)
          .flat_map { |pattern| contents.scan(pattern).flatten.compact }
          .uniq

        keys.each do |key|
          unless key.start_with?(I18N_NAMESPACE)
            errors << "unscoped IDS translation key in #{path}: #{key}"
          end
        end
      end
    end

    def relative_files(glob)
      Dir.glob(@root.join(glob), File::FNM_EXTGLOB)
        .select { |path| File.file?(path) }
        .map { |path| Pathname(path).relative_path_from(@root).to_s }
        .sort
    end
  end
end
