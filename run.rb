require 'rubygems' # require ruby gems for faster csv includsion
require 'fastercsv' # use fastercsv because running on Ruby 1.8
require 'referrers' 


# This is a test to see if I can create a referrer, look up if it is from a search engine
# and return the search engine name and keywords if so

# Process the input CSV file as an array of arrays

input_data = FasterCSV.read("input-data.txt", :headers => true)
FasterCSV.open("output-data.csv", "w") do |csv|
	input_data.each do | i |
		# create a new referrer, using the values specified in the input line 'i'
		r = Referrer.new(i['visit_referrer_source'], i['visit_referrer_medium'], i['visit_referrer_medium,visit_referrer_term'], i['visit_referrer_content'], i['visit_referrer_campaign'], i['visit_page_referrer'])

		# now output the modified values to the csv file
		csv << [i['user_id'], i['visit_id'], r.source, r.medium, r.term, r.content, r.campaign, r.page_referrer, r.referral_path] 
	end
end
