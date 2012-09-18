require 'uri'
require 'cgi'
require 'search_engines'

class Referrer

	# constructor should check if url is a valid search engine string and return false if not
	def initialize(url)
		@url = URI(url)
		@search_engine_name = is_search_engine?
		@search_engine_keywords = get_keywords
		@referrer_name = is_referrer?
	end

	# looks up which search engine. Returns 'nil' if not found 
	def is_search_engine?
		$SEARCH_ENGINE_LOOKUP.map { |pattern, search_engine| if @url.host =~ pattern then search_engine end }.compact[0]
	end

	# returns keywords parsed from the url query string, IF referrer is a recognised search engine AND if the keyword query parameter (e.g. 'q') is found
	def get_keywords
		# only get_keywords if is_search_engine?, otherwise return nil
		if is_search_engine?
			# get the keyword_parameter
			keyword_parameter = $QUERY_PARAMETER_LOOKUP.fetch(@search_engine_name)
			# now use it to fetch the actual keywords from the query string
			unless @url.query.nil?
				query_parameters = CGI.parse(@url.query)
				if query_parameters.has_key?(keyword_parameter)
					return query_parameters[keyword_parameter].to_s
				end
			end
		end
	end

	# is_referrer? checks if referrer is a search engine, returns nil if so and the host if not
	def is_referrer?
		unless is_search_engine?
			return @url.host
		end
	end
	
end


