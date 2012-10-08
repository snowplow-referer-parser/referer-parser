require 'attlib'

describe Referrer do
	it "Should correctly parse Google.com search strings" do
		ref = Referrer.new('http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari&tbo=d&biw=768&bih=900&source=lnms&tbm=isch&ei=t9fTT_TFEYb28gTtg9HZAw&sa=X&oi=mode_link&ct=mode&cd=2&sqi=2&ved=0CEUQ_AUoAQ')
		ref.keywords.should eql "gateway oracle cards denise linn"
	end

	it "Should correct parse Google.co.uk search strings" do
		ref = Referrer.new('http://www.google.co.uk/search?hl=en&client=safari&q=psychic+bazaar&oq=psychic+bazaa&aq=0&aqi=g1&aql=&gs_l=mobile-gws-serp.1.0.0.61498.64599.0.66559.12.9.1.1.2.2.2407.10525.6-2j0j1j3.6.0...0.0.DiYO_7K_ndg&mvs=0')
		ref.keywords.should eql "psychic bazaar"
	end

	it "Should NOT identify Facebook as a search engine" do
	ref = Referrer.new('http://www.facebook.com/l.php?u=http%3A%2F%2Fpsy.bz%2FLtPadV&h=MAQHYFyRRAQFzmokHhn3w4LGWVzjs7YwZGejw7Up5TqNHIw')
	ref.is_search_engine?.should eql nil
	end

	# TO DO build out more tests, including referrers that are NOT search engines

end