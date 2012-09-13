require 'uri'
require 'cgi'

module SearchEngineReferer
	# ----------------------------
	# DICTIONARY OF SEARCH ENGINES
	# ----------------------------
	class SearchEngine

		# 3 key bits of information are required on each search engine:
		def initialize(name, match_pattern, query_parameter)
			@name = name			
			@patterns = [match_pattern]		# put the string in an array
			@query_parameter = query_parameter	# Assume to start off with that the query parameter is a single valued string
		
		end

		def to_s
			return "name: ", @name, "patterns: ", @patterns, "query parameter: ", @query_parameter
		end

		# Add a new pattern for a search engine. Note that all the patterns are grouped into a single array of patterns (@patterns)
		def add_match_pattern(new_pattern)
			@patterns.push(new_pattern) 		# add the new pattern to the end of the patterns array 
		end

		# This returns a hash map where the key is the pattern and the value is the name of the search engine
		# Used to build a search engine dictionary, to enable lookups by pattern
		def get_patterns
			return Hash[ @patterns.map { |pattern| [@pattern, @name] } ]
		end

	end

	# Now we use the above class to create our dictionary
	# TODO: autogenerate the dictionary from a YAML file

	google = SearchEngine.new("Google", "google.com", 'q')
	google.add_match_pattern('google.co.uk')
	bing = SearchEngine.new("Bing", "bing.com", q)
	yahoo = SearchEngine.new("Yahoo!", "yahoo.com", p)

	search_engines_array = [google, bing, yahoo]

	# Now collate the above into a search engine name => query parameter hash to lookup the parameter


	class SearchEngineReferer

		# constructor should check if url is a valid search engine string and return false if not
		def initialize(url)
			@url = uri.parse(url)
		end

		# looks up which search engine. Returns 'nil' if not found 
		def which_search_engine?

		end

		# returns keywords parsed from the search engine url query string
		def keywords
			# execute code similar to that I've already written
		end

		# checks if the query string contains the relevant parameter
		def has_keywords_parameter?
			#
		end

	end

end

