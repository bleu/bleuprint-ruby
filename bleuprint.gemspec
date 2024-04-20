require_relative "lib/bleuprint/version"

Gem::Specification.new do |spec|
  spec.name = "bleuprint"
  spec.version = "0.1.8"
  spec.authors = ["José Ribeiro", "João Victor Assis"]
  spec.email = ["jose@bleu.studio", "joao@bleu.studio"]

  spec.summary = "tools for developing RoR apps at bleu"
  spec.homepage = "https://github.com/bleu-fi/bleuprint-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bleu-fi/bleuprint-ruby/issues",
    "changelog_uri" => "https://github.com/bleu-fi/bleuprint-ruby/releases",
    "source_code_uri" => "https://github.com/bleu-fi/bleuprint-ruby",
    "github_repo" => "ssh://github.com/bleu-fi/bleuprint-ruby",
    "homepage_uri" => spec.homepage,
    "rubygems_mfa_required" => "true",
    "allowed_push_host" => "https://rubygems.pkg.github.com/bleu-fi"
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[LICENSE.txt README.md {exe,lib}/**/*]).reject { |f| File.directory?(f) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "activemodel", "~> 7.1"
  spec.add_dependency "activesupport", "~> 7.1"
  spec.add_dependency "after_commit_everywhere", "~> 1.4"
  spec.add_dependency "rails", "~> 7.1"
end
