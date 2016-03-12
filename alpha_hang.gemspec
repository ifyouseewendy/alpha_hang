# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alpha_hang/version'

Gem::Specification.new do |spec|
  spec.name          = "alpha_hang"
  spec.version       = AlphaHang::VERSION
  spec.authors       = ["Di Wen"]
  spec.email         = ["ifyouseewendy@gmail.com"]

  spec.summary       = %q{A Ruby-based AI against Hangman.}
  spec.description   = %q{A Ruby-based AI against Hangman.}
  spec.homepage      = "http://github.com/ifyouseewendy/alpha_hang"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'httparty', "~> 0.13"
  spec.add_dependency 'activesupport', "~> 4.2"

  spec.required_ruby_version = '>= 2.3.0'
end
