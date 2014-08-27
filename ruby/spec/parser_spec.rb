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

  describe "exceptions" do
    it "should raise UnsupportedFormatError" do
      lambda { default_parser.update(__FILE__) }.should raise_error(RefererParser::UnsupportedFormatError)
    end

    it "should raise CorruptReferersError with invalid json" do
      lambda { default_parser.update(fixture('invalid.json')) }.should raise_error(RefererParser::CorruptReferersError)
    end

    it "should raise CorruptReferersError with invalid yaml" do
      lambda { default_parser.update(fixture('invalid.yml')) }.should raise_error(RefererParser::CorruptReferersError)
    end

    it "should raise CorruptReferersError with valid file with invalid data" do
      lambda { default_parser.update(fixture('referer-tests.json')) }.should raise_error(RefererParser::CorruptReferersError)
    end

    it "should raise InvalidUriError with insane" do
      lambda { default_parser.parse('>total gibberish<') }.should raise_error(RefererParser::InvalidUriError)
    end

    it "should raise InvalidUriError with non http(s)" do
      lambda { default_parser.parse('ftp://ftp.really.com/whatever.json') }.should raise_error(RefererParser::InvalidUriError)
    end
  end

  describe "with the default parser" do
    it "should have a non-empty domain_index" do
      default_parser.instance_variable_get(:@domain_index).should_not be_empty
    end

    it "should have a non-empty name_hash" do
      default_parser.instance_variable_get(:@name_hash).should_not be_empty
    end

    it "should be clearable" do
      default_parser.clear!
      default_parser.instance_variable_get(:@name_hash).should be_empty
      default_parser.instance_variable_get(:@domain_index).should be_empty
    end

    it "should be updatable" do
      size = default_parser.instance_variable_get(:@domain_index).size
      default_parser.update(fixture('internal.json'))
      default_parser.instance_variable_get(:@domain_index).size.should > size
    end
  end

  describe "with the internal parser" do
    it "should have internal mediums only" do
      internal_parser.instance_variable_get(:@domain_index).each_value do |(arr)|
        path, name_key = arr[0], arr[1]
        internal_parser.instance_variable_get(:@name_hash)[name_key][:medium].should == 'internal'
      end
    end
  end

  describe "with the remote parser" do
    # These are combined here to reduce network fetches
    it "should have a non-empty domain_index and name_hash" do
      remote_parser.instance_variable_get(:@domain_index).should_not be_empty
      remote_parser.instance_variable_get(:@name_hash).should_not be_empty
    end
  end

  describe "sample fixtures" do
    # Include our internal data as well
    JSON.parse(File.read(File.join(File.dirname(__FILE__), 'fixtures', 'referer-tests.json'))).each do |fixture|
      it fixture['spec'] do
        parsed_as_string, parsed_as_uri = nil, nil
        lambda { parsed_as_string = combined_parser.parse(fixture['uri']) }.should_not raise_error
        lambda { parsed_as_uri = combined_parser.parse(URI.parse(fixture['uri'])) }.should_not raise_error

        ['source', 'term', 'known', 'medium'].each do |key|
          parsed_as_uri[key.to_sym].should == fixture[key]
          parsed_as_string[key.to_sym].should == fixture[key]
        end
      end
    end
  end
  
  describe "general behavior" do
    it "should return the better result when the referer contains two or more parameters" do
      parsed = default_parser.parse("http://search.tiscali.it/?tiscalitype=web&collection=web&q=&key=hello")
      parsed[:term].should == "hello"
    end

    it "Should return the better result when the referer contains same parameters" do
      parsed = default_parser.parse("http://search.tiscali.it/?tiscalitype=web&collection=web&key=&key=hello")
      parsed[:term].should == "hello"
    end
  end
end
