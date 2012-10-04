require 'yaml'

se = YAML.load_file('search_engines.yml')

# Create a hash of search engine domains, that we will perform lookups 
# to test if referrers are search engines and look up the corresponding query parameters

search_engine_domain_lookups = Hash.new # blank map to start with

se.each do | search_engine_name, search_engine_data |
	search_engine_data['domains'].each do | domain |
		puts domain + " " + search_engine_name+ " " + search_engine_data['parameters']
		new_domain = { domain => { "name" => search_engine_name, "parameter" => search_engine_data['parameters'] } }
		search_engine_domain_lookups.merge!(new_domain) 
	end
end