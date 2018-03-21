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
# Copyright:: Copyright (c) 2014 Inside Systems Inc
# License::   Apache License Version 2.0

# frozen_string_literal: true

require 'uri'
require 'cgi'

module RefererParser
  class Parser
    DefaultFile = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'data', 'referers.json')).freeze

    # Create a new parser from one or more filenames/uris, defaults to ../data/referers.json
    def initialize(uris = DefaultFile)
      @domain_index ||= {}
      @name_hash ||= {}

      update(uris)
    end

    # Update the referer database with one or more uris
    def update(uris)
      [uris].flatten.each do |uri|
        deserialize_referer_data(read_referer_data(uri), File.extname(uri).downcase)
      end

      true
    end

    # Clean out the database
    def clear!
      @domain_index = {}
      @name_hash = {}

      true
    end

    # Add a referer to the database with medium, name, domain or array of domains, and a parameter or array of parameters
    # If called manually and a domain is added to an existing entry with a path, you may need to call optimize_index! afterwards.
    def add_referer(medium, name, domains, parameters = nil)
      # The same name can be used with multiple mediums so we make a key here
      name_key = "#{name}-#{medium}"

      # Update the name has with the parameter and medium data
      @name_hash[name_key] = { source: name, medium: medium, parameters: [parameters].flatten }

      # Update the domain to name index
      [domains].flatten.each do |domain_url|
        domain, *path = domain_url.split('/')
        domain = Regexp.last_match(1) if domain =~ /\Awww\.(.*)\z/i

        domain.downcase!

        @domain_index[domain] ||= []
        @domain_index[domain] << if !path.empty?
                                   ['/' + path.join('/'), name_key]
                                 else
                                   ['/', name_key]
                                 end
      end
    end

    # Prune duplicate entries and sort with the most specific path first if there is more than one entry
    # In this case, sorting by the longest string works fine
    def optimize_index!
      @domain_index.each do |key, _val|
        # Sort each path/name_key pair by the longest path
        @domain_index[key].sort! do |a, b|
          b[0].size <=> a[0].size
        end.uniq!
      end
    end

    # Given a string or URI, return a hash of data
    def parse(obj)
      url = obj.is_a?(URI) ? obj : URI.parse(obj.to_s)

      unless ['android-app', 'http', 'https'].include?(url.scheme)
        raise InvalidUriError, "Only Android-App, HTTP, and HTTPS schemes are supported -- #{url.scheme}"
      end

      data = { known: false, uri: url.to_s }

      domain, name_key = domain_and_name_key_for(url)
      if domain && name_key
        referer_data = @name_hash[name_key]
        data[:known] = true
        data[:source] = referer_data[:source]
        data[:medium] = referer_data[:medium]
        data[:domain] = domain

        # Parse parameters if the referer uses them
        if url.query && referer_data[:parameters]
          query_params = CGI.parse(url.query)
          referer_data[:parameters].each do |param|
            # If there is a matching parameter, get the first non-blank value
            unless (values = query_params[param]).empty?
              data[:term] = values.reject { |v| v.strip == '' }.first
              break if data[:term]
            end
          end
        end
      end

      data
    rescue URI::InvalidURIError
      raise InvalidUriError.new("Unable to parse URI, not a URI? -- #{obj.inspect}", $ERROR_INFO)
    end

    protected

    # Determine the correct name_key for this host and path
    def domain_and_name_key_for(uri)
      # Create a proc that will return immediately
      check = proc do |domain|
        domain.downcase!
        if paths = @domain_index[domain]
          paths.each do |path, name_key|
            return [domain, name_key] if uri.path.include?(path)
          end
        end
      end

      # First check hosts with and without the www prefix with the path
      if uri.host =~ /\Awww\.(.+)\z/i
        check.call Regexp.last_match(1)
      else
        check.call uri.host
      end

      # Remove subdomains until only three are left (probably good enough)
      host_arr = uri.host.split('.')
      while host_arr.size > 2
        host_arr.shift
        check.call host_arr.join('.')
      end

      nil
    end

    def deserialize_referer_data(data, ext)
      # Parse the loaded data with the correct parser
      deserialized_data = if ['.yml', '.yaml'].include?(ext)
                            deserialize_yaml(data)
                          elsif ext == '.json'
                            deserialize_json(data)
                          else
                            raise UnsupportedFormatError, "Only yaml and json file formats are currently supported -- #{@msg}"
      end

      begin
        parse_referer_data deserialized_data
      rescue StandardError
        raise CorruptReferersError.new("Unable to parse data file -- #{$ERROR_INFO.class} #{$ERROR_INFO}", $ERROR_INFO)
      end
    end

    def deserialize_yaml(data)
      require 'yaml'
      YAML.safe_load(data)
    rescue Exception => e
      raise CorruptReferersError.new("Unable to YAML file -- #{e}", e)
    end

    def deserialize_json(data)
      begin
        require 'oj'
        Oj.load(data)
      rescue LoadError => e
        require 'json'
        JSON.parse(data)
      end
    rescue JSON::ParserError
      raise CorruptReferersError.new("Unable to JSON file -- #{$ERROR_INFO}", $ERROR_INFO)
    end

    def read_referer_data(uri)
      # Attempt to read the data from the network if application, or the file on the local system
      if uri =~ /\A(?:ht|f)tps?:\/\//
        require 'open-uri'
        begin
          open(uri).read
        rescue OpenURI::HTTPError
          raise InvalidUriError.new("Cannot load referer data from URI #{uri} -- #{$ERROR_INFO}", $ERROR_INFO)
        end
      else
        File.read(uri)
      end
    end

    # Create an index that maps domains/paths to their name/medium and a hash that contains their metadata
    # The index strips leading www in order to keep the index smaller
    # Format of the domain_index:
    #   { domain => [[path1, name_key], [path2, name_key], ... ] }
    # Format of the name_hash:
    #   { name_key => {:source, :medium, :parameters} }
    def parse_referer_data(data)
      data.each do |medium, name_hash|
        name_hash.each do |name, name_data|
          add_referer(medium, name, name_data['domains'], name_data['parameters'])
        end
      end

      optimize_index!
    rescue StandardError
      raise CorruptReferersError.new('Unable to parse referer data', $ERROR_INFO)
    end
  end
end
