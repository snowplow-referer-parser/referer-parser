# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'attlib/version'

Gem::Specification.new do |gem|
  gem.name          = "attlib"
  gem.version       = SnowPlow::Attlib::VERSION
  gem.authors       = ["Yali Sassoon"]
  gem.email         = ["yali@snowplowanalytics.com"]
  gem.description   = %q{Library for extracting search marketing attribution data from referrer URLs}
  gem.summary       = %q{Library for extracting search marketing attribution data from referrer URLs. This is used by SnowPlow (http://github.com/snowplow/snowplow). However, our hope is that this library (and the search engines YAML) will be extended by anyone interested in parsing search engine referrer data.}
  gem.homepage      = "http://github.com/snowplow/attlib"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec", "~> 2.6"
end
