# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'streamable/version'

Gem::Specification.new do |spec|
  spec.name          = "streamable-api"
  spec.version       = Streamable::VERSION
  spec.authors       = ["Chris Atanasian"]
  spec.email         = ["catanasian@gmail.com"]

  spec.summary       = %q{Unofficial Ruby API wrapper for Streamable}
  spec.homepage      = "http://github.com/chrisatanasian/streamable-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "json"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "shoulda"
  spec.add_development_dependency "rr"
end
