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

  spec.summary       = %q{Generate LGTM image from a source image and copy to clipboard.}
  spec.description   = %q{Generate LGTM image from URL or file with smart text colors and positions. Support direct clipboard paste to github's comment box or Slack on MacOSX.}
  spec.homepage      = "http://github.com/phradion/lgtm_hd"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|images)/}) }
  spec.bindir        = "bin"
  spec.executables   = "lgtm_hd"
  #spec.files.grep(%r{^bin/}) { |f| File.basename(f) }.reject { |f| f.match(%r{^(console|setup)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "3.6.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 1.0.0"
  spec.add_runtime_dependency "open_uri_redirections"
  spec.add_runtime_dependency "commander", "4.4.3"
  spec.add_runtime_dependency "clipboard", "1.1.1"
  spec.add_runtime_dependency "os", "1.0.0"
  spec.add_runtime_dependency "mini_magick", "4.7.0"
end
