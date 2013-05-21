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

require 'referer-parser'
require 'uri'

describe RefererParser::Referer do

  GOOGLE_COM_REFERER   = 'http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari&tbo=d&biw=768&bih=900&source=lnms&tbm=isch&ei=t9fTT_TFEYb28gTtg9HZAw&sa=X&oi=mode_link&ct=mode&cd=2&sqi=2&ved=0CEUQ_AUoAQ'
  GOOGLE_CO_UK_REFERER = 'http://www.google.co.uk/search?hl=en&client=safari&q=psychic+bazaar&oq=psychic+bazaa&aq=0&aqi=g1&aql=&gs_l=mobile-gws-serp.1.0.0.61498.64599.0.66559.12.9.1.1.2.2.2407.10525.6-2j0j1j3.6.0...0.0.DiYO_7K_ndg&mvs=0'
  FACEBOOK_COM_REFERER = 'http://www.facebook.com/l.php?u=http%3A%2F%2Fpsy.bz%2FLtPadV&h=MAQHYFyRRAQFzmokHhn3w4LGWVzjs7YwZGejw7Up5TqNHIw'

  it "Should be initializable with an external referers.yml" do
    external_referer = File.join(File.dirname(__FILE__), '..', 'data', 'referers.yml') # Using the bundled referers.yml in fact
    uri = URI.parse(GOOGLE_COM_REFERER)
    r = RefererParser::Referer.new(uri, external_referer)
    r.referer.should eql "Google" 
  end
  
  it "Should be initializable without an external referers.yml" do
    uri = URI.parse(GOOGLE_COM_REFERER)
    r = RefererParser::Referer.new(uri)
    r.referer.should eql "Google"   
  end
  
  it "Should correctly parse a google.com referer URL" do
    r = RefererParser::Referer.new(GOOGLE_COM_REFERER)
    r.known?.should eql true
    r.referer.should eql "Google"
    r.search_parameter.should eql "q"
    r.search_term.should eql "gateway oracle cards denise linn"
    r.uri.host.should eql "www.google.com"
  end

  it "Should correctly extract a google.co.uk search term" do
    r = RefererParser::Referer.new(GOOGLE_CO_UK_REFERER)
    r.search_term.should eql "psychic bazaar"
  end

  it "Should not identify Facebook as a known referer" do
    r = RefererParser::Referer.new(FACEBOOK_COM_REFERER)
    r.known?.should eql false
  end

  it "Should be initializable with an existing URI object" do
    uri = URI.parse(GOOGLE_COM_REFERER)
    r = RefererParser::Referer.new(uri)
    r.referer.should eql "Google"
  end

end
