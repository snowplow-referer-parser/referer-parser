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

require 'attlib/referers'
require 'uri'
require 'cgi'

class RefererParser

	attr_reader :url,
		:known,
	            :referer,
	            :parameters,
	            :keywords

	# Can be interrogated with .known? too.
	alias_method :known?, :known

	def initialize(referer_url)

		# TODO: add support for already a URL

		# Check for 

		# Check if the URI is valid
		if uri?(referer_url)
			@url = URI(referer_url)
		else
			# Otherwise the URI is not valid
			raise ArgumentError, "'#{url}' is not a valid URL to parse"
		end

		referer = Referer.get_referer(@url)
		unless referer.nil?
			@known = true
			@referer = referer['name']
			@parameters = referer['parameters']
			@keywords = get_keywords(@url, @parameters)
		else
			@known = false
			@referer, @parameters = nil # Being explicit
			@keywords = []
		end
	end

	private

	# Static method to get the keywords from a `url`,
	# where keywords are stored against one of the
	# `possible_parameters` in the querystring
	def self.get_keywords(url, possible_parameters)

		# Only get keywords if there's a query string to extract them from...
		if url.query
			parameters = CGI.parse(url.query)

			# Try each possible keyword parameter with the querystring until one returns a result
			possible_parameters.each do | pp |
				if parameters.has_key?(pp)
					return parameters[pp]
				end
			end
		end

		return [] # No keywords to return
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