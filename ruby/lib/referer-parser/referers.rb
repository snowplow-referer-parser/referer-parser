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

require 'yaml'

# This module processes the referers.yml file and
# uses it to create a global hash that is used to
# lookup URLs to see if they are known referers
# (e.g. search engines)
module RefererParser
  module Referers

    # Returns the referer indicated by
    # the given `uri`
    def self.get_referer(uri)
      # Check if domain+path matches (e.g. google.co.uk/products)
      referer = @referers[uri.host + uri.path]
      if referer.nil?
        # Check if domain only matches (e.g. google.co.uk)
        referer = @referers[uri.host]
      end
      referer
    end

    private # -------------------------------------------------------------
    
    # Returns the path to the YAML
    # file of referers
    def self.get_yaml_file(referer_file = nil)
      if referer_file.nil?
        File.join(File.dirname(__FILE__), '..', '..', 'data', 'referers.yml')
      else
        referer_file
      end
    end

    # Initializes a hash of referers
    # from the supplied YAML file
    def self.load_referers_from_yaml(yaml_file)
      
      unless File.exist?(yaml_file) and File.file?(yaml_file)
        raise ReferersYamlNotFoundError, "Could not find referers YAML file at '#{yaml_file}'"
      end

      # Load referer data stored in YAML file
      begin
        yaml = YAML.load_file(yaml_file)['search'] # TODO: fix this when we support the other types
      rescue error
        raise CorruptReferersYamlError.new("Could not parse referers YAML file '#{yaml_file}'", error)
      end
      @referers = load_referers(yaml)
    end

    # Validate and expand the `raw_referers`
    # array, building a hash of referers as
    # we go
    def self.load_referers(raw_referers)

      # Validate the YAML file, building the lookup
      # hash of referer domains as we go
      referers = Hash.new
      raw_referers.each { | referer, data |
        if data['parameters'].nil?
          raise CorruptReferersYamlError, "No parameters found for referer '#{referer}'"
        end
        if data['domains'].nil? 
          raise CorruptReferersYamlError, "No domains found for referer '#{referer}'"
        end
        
        data['domains'].each do | domain |
          domain_pair = { domain => { "name" => referer,
                                      "parameters" => data['parameters']}}
          referers.merge!(domain_pair)
        end
      }
      return referers 
    end
  end
end
