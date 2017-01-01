# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'irkit_admin/version'

Gem::Specification.new do |spec|
  spec.name          = "irkit_admin"
  spec.version       = IRKitAdmin::VERSION
  spec.authors       = ["Shimpei Makimoto"]
  spec.email         = ["makimoto@tsuyabu.in"]

  spec.summary       = %q{Lightweight admin tool for IRKit}
  spec.homepage      = "https://github.com/makimoto/irkit_admin"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_dependency "puma"
  spec.add_dependency "sinatra"
  spec.add_dependency "omniauth-google-oauth2"
  spec.add_dependency "haml"
  spec.add_dependency "denv"
end
