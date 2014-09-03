# Copyright (c) 2014 Inside Systems, Inc All rights reserved.
#
# This program is licensed to you under the Apache License Version 2.0,
# and you may not use this file except in compliance with the Apache License Version 2.0.
# You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the Apache License Version 2.0 is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.

# Author::    Kelley Reynolds (mailto:kelley@insidesystems.net)
# Copyright:: Copyright (c) 2014 Inside Systems, Inc
# License::   Apache License Version 2.0

require 'spec_helper'

describe RefererParser::Parser do
  let(:remote_file) { "https://raw.githubusercontent.com/snowplow/referer-parser/master/ruby/data/referers.json" }
  let(:default_parser) { RefererParser::Parser.new }
  let(:internal_parser) { RefererParser::Parser.new(fixture('internal.json')) }
  let(:combined_parser) { RefererParser::Parser.new([RefererParser::Parser::DefaultFile, fixture('internal.json')]) }
  let(:remote_parser) { RefererParser::Parser.new(remote_file) }
  let(:domain_index) { parser.instance_variable_get(:@domain_index) }
  let(:name_hash) { parser.instance_variable_get(:@name_hash) }

  # This gets overridden for different parsers in subsections
  let(:parser) { default_parser }

  describe "exceptions" do
    it "should raise UnsupportedFormatError" do
      lambda { parser.update(__FILE__) }.should raise_error(RefererParser::UnsupportedFormatError)
    end

    it "should raise CorruptReferersError with invalid json" do
      lambda { parser.update(fixture('invalid.json')) }.should raise_error(RefererParser::CorruptReferersError)
    end

    it "should raise CorruptReferersError with invalid yaml" do
      lambda { parser.update(fixture('invalid.yml')) }.should raise_error(RefererParser::CorruptReferersError)
    end

    it "should raise CorruptReferersError with valid file with invalid data" do
      lambda { parser.update(fixture('referer-tests.json')) }.should raise_error(RefererParser::CorruptReferersError)
    end

    it "should raise InvalidUriError with insane" do
      lambda { parser.parse('>total gibberish<') }.should raise_error(RefererParser::InvalidUriError)
    end

    it "should raise InvalidUriError with non http(s)" do
      lambda { parser.parse('ftp://ftp.really.com/whatever.json') }.should raise_error(RefererParser::InvalidUriError)
    end
  end

  describe "with the default parser" do
    it "should have a non-empty domain_index" do
      domain_index.should_not be_empty
    end

    it "should have a non-empty name_hash" do
      name_hash.should_not be_empty
    end

    it "should be clearable" do
      parser.clear!
      name_hash.should be_empty
      domain_index.should be_empty
    end

    it "should be updatable" do
      size = domain_index.size
      parser.update(fixture('internal.json'))
      domain_index.size.should > size
    end
  end

  describe "with the internal parser" do
    let(:parser) { internal_parser }

    it "should have internal mediums only" do
      domain_index.each_value do |(arr)|
        path, name_key = arr[0], arr[1]
        name_hash[name_key][:medium].should == 'internal'
      end
    end
  end

  describe "with the remote parser" do
    let(:parser) { remote_parser }

    # These are combined here to reduce network fetches
    it "should have a non-empty domain_index and name_hash" do
      domain_index.should_not be_empty
      name_hash.should_not be_empty
    end
  end

  describe "sample fixtures" do
    let(:parser) { combined_parser }
    # Include our internal data as well
    JSON.parse(File.read(File.join(File.dirname(__FILE__), 'fixtures', 'referer-tests.json'))).each do |fixture|
      it fixture['spec'] do
        parsed_as_string, parsed_as_uri = nil, nil
        lambda { parsed_as_string = parser.parse(fixture['uri']) }.should_not raise_error
        lambda { parsed_as_uri = parser.parse(URI.parse(fixture['uri'])) }.should_not raise_error

        ['source', 'term', 'known', 'medium'].each do |key|
          parsed_as_uri[key.to_sym].should == fixture[key]
          parsed_as_string[key.to_sym].should == fixture[key]
        end
      end
    end
  end
  
  describe "general behavior" do
    it "should return the better result when the referer contains two or more parameters" do
      parsed = parser.parse("http://search.tiscali.it/?tiscalitype=web&collection=web&q=&key=hello")
      parsed[:term].should == "hello"
    end

    it "should return the better result when the referer contains same parameters" do
      parsed = parser.parse("http://search.tiscali.it/?tiscalitype=web&collection=web&key=&key=hello")
      parsed[:term].should == "hello"
    end

    it "should return the normalized domain" do
      parsed = parser.parse("http://it.images.search.YAHOO.COM/images/view;_ylt=A0PDodgQmGBQpn4AWQgdDQx.;_ylu=X3oDMTBlMTQ4cGxyBHNlYwNzcgRzbGsDaW1n?back=http%3A%2F%2Fit.images.search.yahoo.com%2Fsearch%2Fimages%3Fp%3DEarth%2BMagic%2BOracle%2BCards%26fr%3Dmcafee%26fr2%3Dpiv-web%26tab%3Dorganic%26ri%3D5&w=1064&h=1551&imgurl=mdm.pbzstatic.com%2Foracles%2Fearth-magic-oracle-cards%2Fcard-1.png&rurl=http%3A%2F%2Fwww.psychicbazaar.com%2Foracles%2F143-earth-magic-oracle-cards.html&size=2.8+KB&name=Earth+Magic+Oracle+Cards+-+Psychic+Bazaar&p=Earth+Magic+Oracle+Cards&oid=f0a5ad5c4211efe1c07515f56cf5a78e&fr2=piv-web&fr=mcafee&tt=Earth%2BMagic%2BOracle%2BCards%2B-%2BPsychic%2BBazaar&b=0&ni=90&no=5&ts=&tab=organic&sigr=126n355ib&sigb=13hbudmkc&sigi=11ta8f0gd&.crumb=IZBOU1c0UHU")
      parsed[:domain].should == "images.search.yahoo.com"
    end
  end

  describe "optimize_index" do
    let(:domains) { ['fnord.com', 'fnord.com', 'fnord.com/path'] }

    before do
      parser.add_referer('internal', 'Fnord', domains)
    end

    it "should have out of order and duplicate domains before optimization" do
      domain_index['fnord.com'].transpose.first.should == ['/', '/', '/path']
    end

    it "should have out of order domains before optimization" do
      parser.optimize_index!
      domain_index['fnord.com'].transpose.first.should == ['/path', '/']
    end
  end

  describe "add_referer" do
    it "should add a referer to the domain_index" do
      domain_index['fnord.com'].should be_nil
      parser.add_referer('internal', 'Fnord', 'fnord.com')
      domain_index['fnord.com'].should_not be_nil
    end

    it "should add a referer with multiple domains to the domain_index" do
      domain_index['fnord.com'].should be_nil
      domain_index['boo.com'].should be_nil
      parser.add_referer('internal', 'Fnord', ['fnord.com', 'boo.com'])
      domain_index['fnord.com'].should_not be_nil
      domain_index['boo.com'].should_not be_nil
    end

    it "should add a referer to the name_hash" do
      name_hash['fnord.com-internal'].should be_nil
      parser.add_referer('internal', 'Fnord', 'fnord.com')
      name_hash['Fnord-internal'].should_not be_nil
    end

    it "should add parameters to the name_hash" do
      parser.add_referer('internal', 'Fnord', 'fnord.com', ['Q', 'q'])
      name_hash['Fnord-internal'][:parameters].should == ['Q', 'q']
    end

    it "should add a single parameter to the name_hash" do
      parser.add_referer('internal', 'Fnord', 'fnord.com', 'q')
      name_hash['Fnord-internal'][:parameters].should == ['q']
    end
  end
end
