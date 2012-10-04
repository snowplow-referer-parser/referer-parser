require 'uri'
require 'cgi'


def get_keywords(input_url)
	referer_url = URI.parse(input_url)
	
	# Only parse the query if a query is present in the URL
	unless referer_url.query.nil?
		query_hash = CGI.parse(referer_url.query)	# query_hash is a map with the query parameters

		# Only fetch the keywords if the keyword parameter is specified
		if query_hash.has_key?("q") 
			keywords = query_hash['q'].to_s 	# q is the keywords
		else
			keywords = ''					# blank
		end
		return keywords
	end
end

# Load all the Google referers into an array
referers = Array.new
File.open("google-referers.txt") do |file|
	while line = file.gets 
		referers.push(line)
	end
end

# Now iterate over the array, fetching keywords from each referer
referers.each{|url| puts (get_keywords(url))}