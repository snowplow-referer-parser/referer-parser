# referer-parser Ruby library

This is the Ruby implementation of [referer-parser][referer-parser], the library for extracting search marketing data from referer _(sic)_ URLs.

The implementation uses the shared 'database' of known referers found in [`referers.yml`][referers-yml].

## Installation

Add this line to your application's Gemfile:

    gem 'referer-parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install referer-parser

## Usage

### To include referer-parser:

```ruby
require 'referer-parser'
```

### To create a parser

Parsers are created by default with the set of included referers but they can also be loaded from another file(s) either during or after instantiation

Creating and modifying the parser:

```ruby
# Default parser
parser = RefererParser::Parser.new

# Custom parser with local file
parser = RefererParser::Parser.new('/path/to/other/referers.yml')

# From a URI
parser = RefererParser::Parser.new('http://example.com/path/to/other/referers.yml')

# Default referers, then merge in a set of custom internal domains
parser = RefererParser::Parser.new
parser.update('/path/to/internal.yml')

# Default referers, then add your own internal domain inline instead of from a file
parser = RefererParser::Parser.new
parser.add_referer('internal', 'SnowPlow', 'snowplowanalytics.com')

# Clear all of the existing referers
parser.clear!
```

### Using a parser

The parser returns a hash of matching data if it can be found including search terms, medium, and nicely-formatted source name.
If there is no match, :known will be false.

```ruby
parser = RefererParser::Parser.new
parser.parse('http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari')
  # => {
    :known=>true,
    :uri=>"http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari",
    :source=>"Google",
    :medium=>"search",
    :term=>"gateway oracle cards denise linn"
  }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright and license

The referer-parser Ruby library is copyright 2014 Inside Systems, Inc.

Licensed under the [Apache License, Version 2.0][license] (the "License");
you may not use this software except in compliance with the License.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[referer-parser]: https://github.com/snowplow/referer-parser
[referers-yml]: https://github.com/snowplow/referer-parser/blob/master/referers.yml

[license]: http://www.apache.org/licenses/LICENSE-2.0
