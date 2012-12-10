# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'attlib/version'

Gem::Specification.new do |gem|
  gem.name          = "attlib"
  gem.version       = SnowPlow::Attlib::VERSION
  gem.authors       = ["Yali Sassoon"]
  gem.email         = ["yali.sassoon@keplarllp.com"]
  gem.description   = %q{attlib has become referer-parser: http://rubygems.org/gems/referer-parser}
  gem.summary       = %q{attlib has become referer-parser: http://rubygems.org/gems/referer-parser}
  gem.homepage      = "http://github.com/snowplow/attlib"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec", "~> 2.6"
end
