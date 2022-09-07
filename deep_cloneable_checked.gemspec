require_relative 'lib/deep_cloneable_checked/version'

Gem::Specification.new do |spec|
  spec.name          = "deep_cloneable_checked"
  spec.version       = DeepCloneableChecked::VERSION
  spec.authors       = ["Kaori Kohama", "Tinco Andringa"]
  spec.email         = ["kaori@aeroscan.nl", "tinco@aeroscan.nl"]

  spec.summary       = %q{Use this gem to enforce all associations explicitly cloned with deep_clone}
  spec.description   = %q{Use this gem to enforce all associations explicitly cloned with deep_clone}
  spec.homepage      = "https://github.com/aeroscan-nl/deep_cloneable_checked"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/aeroscan-nl/deep_cloneable_checked"
  spec.metadata["changelog_uri"] = "https://github.com/aeroscan-nl/deep_cloneable_checked/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency('deep_cloneable', '~> 3.2.0')
end
