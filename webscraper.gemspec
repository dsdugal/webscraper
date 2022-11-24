# frozen_string_literal: true

Gem::Specification.new do |spec|
  # Specify which Ruby version(s) to use at runtime.
  spec.required_ruby_version = ">= 2.7.6"

  # Specify which Gems (and their versions) are dependencies.
  spec.add_runtime_dependency "digest", "~> 3.1.0"
  spec.add_runtime_dependency "logger", "~> 1.5.1"
  spec.add_runtime_dependency "mongo", "~> 2.18.1"
  # spec.add_runtime_dependency "webcrawler", "~> 0.1.0"
end
