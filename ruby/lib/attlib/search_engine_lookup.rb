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

module SearchEngineLookup

	# Load search engine data stored in YAML file
	se = YAML.load_file(File.join(File.dirname(__FILE__), '..', '..', 'data','search_engines.yml'))

	# Check that none of the values for parameters in the YAML file are nil
	se.each { | search_engine, data | if data['parameters'].nil? then puts "Problematic search engine parameter is: " + search_engine end } 

	# Check that none of the values for domains in the YAML file are nil
	se.each { | search_engine, data | if data['domains'].nil? then puts "Problematic search engine parameter is: " + search_engine end } 

	# Create a hash of search engine domains, that we will perform lookups against
	$SEARCH_ENGINE_LOOKUP = Hash.new # blank map to start with

	# Now populate the lookup hash '$SEARCH_ENGINE_LOOKUP' by transforming the data from the YAML file, stored in 'se'
	se.each do | name, data |
		data['domains'].each do | domain |
			new_domain = { domain => { "name" => name, "parameters" => data['parameters'] } }
			$SEARCH_ENGINE_LOOKUP.merge!(new_domain) 
		end
	end

end