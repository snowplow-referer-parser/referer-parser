# Attlib Ruby library

This is the Ruby implementation of [Attlib] [attlib], the library for extracting search marketing attribution data from referrer URLs.

The implementation uses the shared 'database' of search engines found in [`search_engines.yml`] [search-engines-yml].

## Installation

Add this line to your application's Gemfile:

    gem 'attlib'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attlib

## Usage

Use Attlib like this:

```ruby
require 'attlib'

new_referrer = Referrer.new('http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari')

new_referrer.is_search_engine? 	# True
new_referrer.search_engine 		# 'Google'
new_referrer.keywords 			# 'gateway oracle cards denise linn'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright and license

The Attlib Ruby library is copyright 2012 SnowPlow Analytics Ltd.

Licensed under the [Apache License, Version 2.0] [license] (the "License");
you may not use this software except in compliance with the License.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[attlib]: https://github.com/snowplow/attlib
[search-engines-yml]: https://github.com/snowplow/attlib/blob/master/search-engines.yml