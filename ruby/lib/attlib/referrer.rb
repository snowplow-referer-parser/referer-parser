# Copyright (c) 2012 SnowPlow Analytics Ltd. All rights reserved.
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
# Copyright:: Copyright (c) 2012 SnowPlow Analytics Ltd
# License::   Apache License Version 2.0

require 'attlib/search_engine_lookup'
require 'uri'
require 'cgi'

class Referrer

	attr_reader :referrer_url, :search_engine, :possible_keyword_parameters, :keywords

	def initialize(referrer_url)
		# Check if the URI is valid
		if uri?(referrer_url)
			@referrer_url = URI(referrer_url)

			# Check if the referrer is a search engine and if so, assign the values to :search_engine and :keywords
			
			# First check if the domain + path matches (e.g. google.co.uk/products) any of the search engines in the lookup hash
			if $SEARCH_ENGINE_LOOKUP[@referrer_url.host + @referrer_url.path]
				@search_engine = $SEARCH_ENGINE_LOOKUP[@referrer_url.host + @referrer_url.path]['name']
				@possible_keyword_parameters = $SEARCH_ENGINE_LOOKUP[@referrer_url.host + @referrer_url.path]['parameters']
				@keywords = get_keywords
			
			# If not, check if the domain by itself matches (e.g. google.co.uk)
			elsif $SEARCH_ENGINE_LOOKUP[@referrer_url.host]
				@search_engine = $SEARCH_ENGINE_LOOKUP[@referrer_url.host]['name']
				@possible_keyword_parameters = $SEARCH_ENGINE_LOOKUP[@referrer_url.host]['parameters']
				@keywords = get_keywords
			
			# Otherwise referrer is not a search engine
			else
				@search_engine = nil
				@possible_keyword_parameters = nil
				@keywords = nil
			end
		else
			# Otherwise the URI is not valid
			raise ArgumentError, "#{referrer_url} is not a valid URL"
		end
	end

	def is_search_engine?
		@search_engine
	end

	def get_keywords
		# only get keywords if there's a query string to extract them from...
		if @referrer_url.query
			query_parameters = CGI.parse(@referrer_url.query)

			# try each possible keyword parameter with the query string until one returns a result
			possible_keyword_parameters.each do | parameter |
				if query_parameters.has_key?(parameter)
					return query_parameters[parameter].to_s
				end
			end
		end
	end

	def uri?(string)
		uri = URI.parse(string)
		%w( http https ).include?(uri.scheme)
	rescue URI::BadURIError
		false
	rescue URI::InvalidURIError
		false
	end
end		
