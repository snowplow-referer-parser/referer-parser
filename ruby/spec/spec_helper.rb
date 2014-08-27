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


require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)

require 'yaml'
require 'rspec'
require 'referer-parser'
require 'uri'
require 'json'

module Helpers
  def fixture(filename)
    File.join(File.dirname(__FILE__), 'fixtures', filename)
  end
end

RSpec.configure do |config|
  config.include Helpers
end
  