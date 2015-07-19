# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'detyler/version'

Gem::Specification.new do |spec|
  spec.name          = "detyler"
  spec.version       = Detyler::VERSION
  spec.authors       = ["Andrew Esler"]
  spec.email         = ["aj@esler.co.nz"]

  spec.summary       = %q{Downloads XYZ tiles and stores them}
  spec.description   = %q{Downloads XYZ tiles from within a bounding box at the specified zoom levels and saves them.}
  spec.homepage      = "https://github.com/ajesler/detyler"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry-byebug"

  spec.add_dependency "sqlite3"
  spec.add_dependency "httparty"
  spec.add_dependency "chunky_png"
end
