# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lgtm_hd/version'
require 'rubygems/dependency_installer.rb'

Gem::Specification.new do |spec|
  spec.name          = "lgtm_hd"
  spec.version       = LgtmHD::VERSION
  spec.authors       = ["Huy Dinh"]
  spec.email         = ["phradion@gmail.com"]

  spec.summary       = %q{Generating LGTM image to clipboard.}
  spec.description   = %q{Generating images from user input with LGTM text on it, or fetching images from LGTM.in based on user's query. Finally put the image to clipboard.}
  spec.homepage      = "https://github.com/phradion"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.6", ">= 3.6.0"
  spec.add_runtime_dependency "commander", "~> 4.4", ">= 4.4.3"
  spec.add_runtime_dependency "clipboard", "~> 1.1", ">= 1.1.1"
  spec.add_runtime_dependency "os", "~> 1.0", ">= 1.0.0"
end
