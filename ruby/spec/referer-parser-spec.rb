require 'referer-parser'

describe RefererParser do
	it "Should correctly parse a google.com referer URL" do
		r = RefererParser::Parser.new('http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari&tbo=d&biw=768&bih=900&source=lnms&tbm=isch&ei=t9fTT_TFEYb28gTtg9HZAw&sa=X&oi=mode_link&ct=mode&cd=2&sqi=2&ved=0CEUQ_AUoAQ')
		r.known?.should eql true
		r.referer.should eql "Google"
		r.search_parameter.should eql "q"
		r.search_term.should eql "gateway oracle cards denise linn"
		r.uri.host should eql "google.com"
	end

	it "Should correctly extract a google.co.uk search term" do
		r = RefererParser::Parser.new('http://www.google.co.uk/search?hl=en&client=safari&q=psychic+bazaar&oq=psychic+bazaa&aq=0&aqi=g1&aql=&gs_l=mobile-gws-serp.1.0.0.61498.64599.0.66559.12.9.1.1.2.2.2407.10525.6-2j0j1j3.6.0...0.0.DiYO_7K_ndg&mvs=0')
		r.search_term.should eql "psychic bazaar"
	end

	it "Should not identify Facebook as a known referer" do
	r = RefererParser::Parser.new('http://www.facebook.com/l.php?u=http%3A%2F%2Fpsy.bz%2FLtPadV&h=MAQHYFyRRAQFzmokHhn3w4LGWVzjs7YwZGejw7Up5TqNHIw')
	r.known?.should eql false
	end

	# TODO add more more tests
end