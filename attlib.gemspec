# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'attlib/version'

Gem::Specification.new do |gem|
  gem.name          = "attlib"
  gem.version       = Attlib::VERSION
  gem.authors       = ["Yali Sassoon"]
  gem.email         = ["yali.sassoon@keplarllp.com"]
  gem.description   = %q{Library for extracting search marketing attribution data from referrer URLs}
  gem.summary       = %q{Library for extracting search marketing attribution data from referrer URLs}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec", "~> 2.6"
end
