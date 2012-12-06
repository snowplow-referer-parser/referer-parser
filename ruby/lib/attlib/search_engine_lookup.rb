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


# This module processes the search_engines.yml file and uses it to create a global hash that 
# is used to lookup referrers to see if they are search engines
require 'yaml'

module Referers

	@referers = load_referers(get_yaml_file())

	# Returns the referer indicated in
	# the given `url`
	def self.get_referer(url)
		# First check if the domain + path matches (e.g. google.co.uk/products)
		referer = @referers[url.host + url.path]
		if referer.nil?
			# If not, check if the domain only matches (e.g. google.co.uk)
			referer = @referers[url.host]
		end
		return referer
	end

	private
	
	# Returns the path to the YAML
	# file of referers
	def self.get_yaml_file()
		File.join(File.dirname(__FILE__), '..', '..', 'data', 'referers.yml')
	end

	# Initializes a hash of referers
	# from the supplied YAML file
	def self.load_referers(yaml_file)

		# Load referer data stored in YAML file
		yaml = YAML.load_file(yaml_file)

		# Validate the YAML file
		yaml.each { | referer, data |
			if data['parameters'].nil?
				puts "No parameters supplied for referer '#{referer}'"
				# TODO: throw exception
			end
			if data['domains'].nil?
				puts "No domains supplied for referer '#{referer}'"
				TODO: throw exception
			end 
		} 

		# Build the lookup hash of referer domains
		referer_hash = Hash.new
		yaml.each do | name, data |
			data['domains'].each do | domain |
				domain_pair = { domain => { "name" => name, "parameters" => data['parameters'] } }
				referer_hash.merge!(domain_pair)
			end
		end
		return referer_hash 
	end
end