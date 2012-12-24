# referer-parser Python library

This is the Python implementation of [referer-parser] [referer-parser], the library for extracting search marketing data from referer _(sic)_ URLs.

The implementation uses the shared 'database' of known search engine referers found in [`search.yml`] [search-yml].

## Installation

    pip install referer_parser

## Usage

Create a new instance of a Referer object by passing in the url you want to parse:

```python
from referer_parser import Referer

referer_url = 'http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari'

r = Referer(referer_url)
```

The `r` variable now holds a Referer instance.  The important attributes are:

```python
print(r.known)              # True
print(r.referer)            # 'Google'
print(r.search_parameter)   # 'q'     
print(r.search_term)        # 'gateway oracle cards denise linn'
print(r.uri)                # ParseResult(scheme='http', netloc='www.google.com', path='/search', params='', query='q=gateway+oracle+cards+denise+linn&hl=en&client=safari', fragment='')
```

The `uri` attribute is an instance of ParseResult from the standard libraries `urlparse` module.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright and license

The referer-parser Python library is copyright 2012 Don Spaulding.

Licensed under the [Apache License, Version 2.0] [license] (the "License");
you may not use this software except in compliance with the License.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[referer-parser]: https://github.com/snowplow/referer-parser
[search-yml]: https://github.com/snowplow/referer-parser/blob/master/search.yml

[license]: http://www.apache.org/licenses/LICENSE-2.0
