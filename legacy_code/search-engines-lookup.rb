require 'yaml'

se = YAML.load_file('search_engines.yml')

# check if any of the input parameters are nil
se.each do | search_engine, data |
	if data['parameters'].nil? 
		puts "Problematic search engine parameter is: " + search_engine 
	else
		puts search_engine + "is ok"
	end
end

# check if any of the input domains are nil
se.each do | search_engine, data |
	if data['domains'].nil? 
		puts "Problematic search engine domain is: " + search_engine 
	else
		puts search_engine + "is ok"
	end
end

# Create a hash of search engine domains, that we will perform lookups 
# to test if referrers are search engines and look up the corresponding query parameters

se_lookup = Hash.new # blank map to start with

# Now populate the lookup hash 'se_lookup' by transforming the data from the YAML file, stored in 'se'
se.each do | name, data |
	data['domains'].each do | domain |
		new_domain = { domain => { "name" => name, "parameters" => data['parameters'] } }
		se_lookup.merge!(new_domain) 
	end
end

se_lookup.each { |domain, data| puts "Domain is: " + domain + ".   Name is: " + data['name'] + ". Parameters are: " + data['parameters'].to_s }