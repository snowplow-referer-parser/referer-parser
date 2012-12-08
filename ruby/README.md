# referer-parser Ruby library

This is the Ruby implementation of [referer-parser] [referer-parser], the library for extracting search marketing data from referer (_sic_) URLs.

The implementation uses the shared 'database' of known referers found in [`referers.yml`] [referers-yml].

## Installation

Add this line to your application's Gemfile:

    gem 'referer-parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install referer-parser

## Usage

Use referer-parser like this:

```ruby
require 'referer-parser'

p = RefererParser::Parser.new('http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari')

p.known? 				# => true
p.referer 				# => 'Google'
p.search_parameter      # => 'q'			
p.search_term           # => 'gateway oracle cards denise linn'
p.uri.host              # => 'google.com'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright and license

The referer-parser Ruby library is copyright 2012 SnowPlow Analytics Ltd.

Licensed under the [Apache License, Version 2.0] [license] (the "License");
you may not use this software except in compliance with the License.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[referer-parser]: https://github.com/snowplow/referer-parser
[referers-yml]: https://github.com/snowplow/referer-parser/blob/master/referers.yml