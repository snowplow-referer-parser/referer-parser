# Copyright (c) 2012-2013 Snowplow Analytics Ltd. All rights reserved.
#
# This program is licensed to you under the Apache License Version 2.0,
# and you may not use this file except in compliance with the Apache License Version 2.0.
# You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the Apache License Version 2.0 is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.

# Author::    Yali Sassoon (mailto:support@snowplowanalytics.com)
# Copyright:: Copyright (c) 2012-2013 Snowplow Analytics Ltd
# License::   Apache License Version 2.0

# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'referer-parser/version'

Gem::Specification.new do |gem|
  gem.authors       = ["Yali Sassoon", "Martin Loy", "Alex Dean"]
  gem.email         = ["support@snowplowanalytics.com"]
  gem.description   = %q{Library for extracting marketing attribution data from referer URLs}
  gem.summary       = %q{Library for extracting marketing attribution data (e.g. search terms) from referer (sic) URLs. This is used by Snowplow (http://github.com/snowplow/snowplow). Our hope is that this library (and referers.yml) will be extended by anyone interested in parsing referer URLs.}
  gem.homepage      = "http://github.com/snowplow/referer-parser"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = RefererParser::NAME
  gem.version       = RefererParser::VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec", "~> 2.6"
end
