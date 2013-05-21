# Copyright (c) 2012-2013 Snowplow Analytics Ltd. All rights reserved.
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
# Copyright:: Copyright (c) 2012-2013 Snowplow Analytics Ltd
# License::   Apache License Version 2.0

module RefererParser

  # Errors thrown by RefererParser

  class RefererParserError < StandardError
    attr_reader :original
    def initialize(msg, original=nil);
      super(msg);
      @original = original;
    end
  end

  class InvalidUriError < StandardError
  end

  class ReferersYamlNotFoundError < StandardError
  end

  class CorruptReferersYamlError < StandardError
  end
end