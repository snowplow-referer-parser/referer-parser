require 'rubygems' # require ruby gems for faster csv includsion
require 'fastercsv' # use fastercsv because running on Ruby 1.8
require 'referrers' 


# This is a test to see if I can create a referrer, look up if it is from a search engine
# and return the search engine name and keywords if so

# Process the input CSV file as an array of arrays

input_data = FasterCSV.read("input-data.csv", :headers => true)
FasterCSV.open("output-data.csv", "w", {:force_quotes=>true}) do |csv|
	input_data.each do |i|
		# Process marketing fields related to the visit
		v = Referrer.new(i['visit_referrer_source'], i['visit_referrer_medium'], i['visit_referrer_term'], i['visit_referrer_content'], i['visit_referrer_campaign'], i['visit_page_referrer'])	
		
		# Process marketing fields related to the first_visit
		f = Referrer.new(i['first_visit_referrer_source'], i['first_visit_referrer_medium'], i['first_visit_referrer_term'], i['first_visit_referrer_content'], i['first_visit_referrer_campaign'], i['first_visit_page_referrer'])
		
		# now write the results to a CSV file
		csv << [i['product_sku'],
				i['product_name'],
				i['product_category'],
				i['page_url'],
				i['user_id'], 
				i['cohort'],
				f.source,
				f.medium,
				f.term,
				f.content,
				f.campaign,
				i['first_visit_page_referrer'],
				f.referral_path,
				i['visit_id'], 
				i['dt'],
				i['tm'],
				i['steps_in_visit'],
				v.source, 
				v.medium, 
				v.term, 
				v.content, 
				v.campaign, 
				i['visit_page_referrer'],
				v.referral_path,
				i['order_id'],
				i['page_views'],
				i['add_to_baskets'],
				i['value_added_to_basket'],
				i['remove_from_baskets'],
				i['value_removed_from_basket'],
				i['net_volume_added_to_basket'],
				i['net_value_added_to_basket'],
				i['number_bought'],
				i['revenue']]
	end
end
