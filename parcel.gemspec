# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "parcel/version"

Gem::Specification.new do |spec|
  spec.name          = "parcel"
  spec.version       = Parcel::VERSION
  spec.authors       = ["Tom Grushka"]
  spec.email         = ["tom@dra11y.com"]

  spec.summary       = %q{Integrates Parcel into Rails}
  spec.description   = %q{Replace the asset pipeline with Parcel. Get CSS, JS and HTML live-reloading out of the box. Full ES6 support with require.}
  spec.homepage      = "https://github.com/dra11y/parcel"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "rails", ">= 5.0"
  spec.add_dependency "actioncable", ">= 5.0"
  spec.add_dependency "listen", ">= 3.0"
end
