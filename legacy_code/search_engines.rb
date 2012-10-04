module Search_engines
	# ----------------------------
	# DICTIONARY OF SEARCH ENGINES
	# ----------------------------
	class Search_engine
		# included for the purposes of debugging - remove later
		attr_reader :name, :patterns, :query_parameter

		# 3 key bits of information are required on each search engine:
		def initialize(name, match_pattern, query_parameter)
			@name = name			
			@patterns = [match_pattern]		# convert the inputted string into a regexp pattern, replacing any '.' with '\.' (i.e. escaping full stops)
			@query_parameter = query_parameter	# Assume to start off with that the query parameter is a single valued string. (If not, we'll change this to an array)	
		end

		def to_s
			"name: #{@name}, patterns: , #{@patterns}, query parameter: #{@query_parameter}"
		end

		# Add a new pattern for a search engine. Note that all the patterns are grouped into a single array of patterns (@patterns)
		def add_match_pattern(new_pattern)
			@patterns.push(new_pattern)		# add the new pattern to the end of the patterns array 
		end

		# This returns a hash map where the key is the pattern and the value is the name of the search engine
		# Used to build a search engine dictionary, to enable lookups by pattern
		def get_patterns
			Hash[@patterns.map { |pattern| [pattern, @name] }]
		end

		def get_query_parameters
			Hash[@name, @query_parameter]
		end
	end

	# We need to create 2 dictionaries: 
	# 1. Search engine lookup: looks up which search engine a referrer comes from
	# 2. Query parameter lookup: which parameter to use for a particular search engine
	
	# TODO: autogenerate the dictionaries from a YAML file, instead of the hard code below

	google = Search_engine.new("Google", /google\.com/ , 'q')
	google.add_match_pattern(/google\.co\.uk/)
	google.add_match_pattern(/google\.co/)
	google.add_match_pattern(/google\./)
	bing = Search_engine.new("Bing", /bing\.com/, 'q')
	bing.add_match_pattern(/bing\.co/)
	yahoo = Search_engine.new("Yahoo!", /yahoo\.com/, 'p')
	yahoo.add_match_pattern(/yahoo\.co/)
	amazon = Search_engine.new("Amazon.co.uk", /amazon\.co\.uk/, 'field-keywords')
	ebay = Search_engine.new("eBay.co.uk", /ebay\.co\.uk/, '_nkw')

	# powered by Google
	google.add_match_pattern(/serach\.avg\.com/)
	google.add_match_pattern(/isearch\.avg\.com/)
	google.add_match_pattern(/search\.conduit\.com/)
	google.add_match_pattern(/search\.orange\.co\.uk/)
	google.add_match_pattern(/search\.aol\.com/)
	google.add_match_pattern(/start\.funmoods\.com/)

	# powered by Bing
	bing.add_match_pattern(/easysearch\.org\.uk/)

	search_engines_array = [google, bing, yahoo, amazon, ebay]

	# Create the 1st dictionary, by collating the above into a search engine name => query parameter hash 
	$SEARCH_ENGINE_LOOKUP = {}
	search_engines_array.each do |se|
		$SEARCH_ENGINE_LOOKUP = $SEARCH_ENGINE_LOOKUP.merge(se.get_patterns)
	end

	# Create the 2nd dictionary
	$QUERY_PARAMETER_LOOKUP = {}
	search_engines_array.each do |se|
		$QUERY_PARAMETER_LOOKUP = $QUERY_PARAMETER_LOOKUP.merge(se.get_query_parameters)
	end	

end

