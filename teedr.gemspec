# frozen_string_literal: true

require_relative "lib/teedr/version"

Gem::Specification.new do |spec|
  spec.name    = "teedr"
  spec.version = Teedr::VERSION
  spec.authors = ["brian915"]
  spec.email   = ["brian@brianrunk.net"]

  spec.summary  = "CLI tool for ingesting content into structured feed items"
  spec.homepage = "https://github.com/brian915/teedr"
  spec.license  = "MIT"

  spec.required_ruby_version = ">= 3.2.0"

  spec.files = Dir.glob("{exe,lib}/**/*") + %w[teedr.gemspec Gemfile README.md LICENSE.txt]
  spec.bindir      = "exe"
  spec.executables = ["teedr"]

  spec.add_dependency "thor", "~> 1.5"
end
