# referer-parser Go library

This is the Go implementation of [referer-parser] [referer-parser], the library for extracting search marketing data from referer _(sic)_ URLs.

The implementation uses the shared 'database' of known referers found in [`referers.yml`] [referers-yml].

The Go version of referer-parser is maintained by [Thomas Sileo] [tsileo].

## Installation

```console
$ go get github.com/snowplow/referer-parser/go
```

## Usage

```go
package main

import (
  "log"

  "github.com/snowplow/referer-parser/go"
)

func main() {
  referer_url := "http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari"
  r := refererparser.Parse(referer_url)

  log.Printf("Known:%v", r.Known)
  log.Printf("Referer:%v", r.Referer)
  log.Printf("Medium:%v", r.Medium)
  log.Printf("Search parameter:%v", r.SearchParameter)
  log.Printf("Search term:%v", r.SearchTerm)
  log.Printf("Host:%v", r.URI)
}

```

## referers.yml embed

The [`referers.json`] [referers-yml] is embedded in the package using [`go-bindata`] [go-bindata].

```
$ go-bindata -ignore=\\.yml -pkg refererparser data/...
```

## Copyright and license

The referer-parser Go library is distributed under the MIT License.

Copyright (c) 2014 Thomas Sileo.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

[referer-parser]: https://github.com/snowplow/referer-parser
[referers-yml]: https://github.com/snowplow/referer-parser/blob/master/referers.json

[tsileo]: https://github.com/tsileo
[go-bindata]: https://github.com/jteeuwen/go-bindata
