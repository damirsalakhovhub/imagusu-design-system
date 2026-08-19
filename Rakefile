# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"
require "standard/rake"

Minitest::TestTask.create

desc "Run policy, tests, lint, and package verification"
task default: %i[policy test standard package_smoke]

desc "Verify architecture policy"
task :policy do
  sh "ruby script/verify-policy"
end

desc "Build, install, and require the packaged gem"
task :package_smoke do
  sh "script/package-smoke"
end
