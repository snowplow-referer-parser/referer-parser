# Attlib

Attlib is a Ruby library for extracting search marketing attribution data from referrer URLs.

## Installation

Add this line to your application's Gemfile:

    gem 'attlib'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attlib

## Usage

The library is simple to use:

	require 'attlib'

	new_referrer = Referrer.new('http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari&tbo=d&biw=768&bih=900&source=lnms&tbm=isch&ei=t9fTT_TFEYb28gTtg9HZAw&sa=X&oi=mode_link&ct=mode&cd=2&sqi=2&ved=0CEUQ_AUoAQ') # Initialise the new Referrer object with the referrer URL to be parsed

	new_referrer.is_search_engine? 	# True
	new_referrer.search_engine 		# 'Google'
	new_referrer.keywords 			# 'gateway oracle cards denise linn'

### search_engines.yml

The library identifies whether a URL is a search engine or not by checking it against data in the search_engines.yml file. (Stored in the `/data` folder.) This file, then, is key to the library performing well.

The file lists each search engine by name, and for each, gives a list of the parameters used in that search engine URL to identify the keywords and a list of domains that the search engine operates on:

	google # search engine name
		parameters:
			- 'q' # first parameter
			- 'p' # 2nd parameter
		domains:
			- google.co.uk 	# one domain
			- google.com 	# another domain

The number of search engines and the domains they operate on are constantly changing. We therefore need to keep the search-engines.yml up to date, and hope that the community will help us doing so by contributing to the file over time.

### Attlib in other (non-Ruby) languages

Our intention is to role out Attlib in other languages, but take the same approach. (I.e. base results on the search-engines.yml file.) Our intention is to release a Scala version first. We welcome community contributions for libraries in other languages (e.g. Python).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
