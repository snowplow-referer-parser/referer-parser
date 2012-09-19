require 'uri'
require 'cgi'
require 'search_engines'

class Referrer
	attr_reader :source, :medium, :term, :content, :campaign, :page_referrer, :referral_path

	def initialize(source, medium, term, content, campaign, page_referrer)
		begin
		@page_referrer = URI(page_referrer)
		@referral_path = URI(page_referrer).path
		# set source, medium, term, content, campaign if they are not already set...
			if source.nil? 
				if is_search_engine? 		
					@source = is_search_engine?
					@medium = 'organic'
					@term = get_keywords
					@content = nil
					@campaign = nil
				elsif is_referrer? 
					@source = is_referrer?
					@medium = 'referral'
					@term = nil
					@content = nil
					@campaign = nil
				end
			# ...otherwise they keep their current values
			else
				# parameters have already been set (because e.g. it is a CPC campaign)
				@source = source
				@medium = medium
				@term = term
				@content = content
				@campaign = campaign
			end
		rescue
			puts "Error for page_referrer = #{@page_referrer}"
		end
	end

	# looks up which search engine. Returns 'nil' if not found 
	def is_search_engine?
		$SEARCH_ENGINE_LOOKUP.map { |pattern, search_engine| if @page_referrer.host =~ pattern then search_engine end }.compact[0]
	end

	# returns keywords parsed from the page_referrer query string, IF referrer is a recognised search engine AND if the keyword query parameter (e.g. 'q') is found
	def get_keywords
		# only get_keywords if is_search_engine?, otherwise return nil
		if is_search_engine?
			# get the keyword_parameter
			keyword_parameter = $QUERY_PARAMETER_LOOKUP.fetch(@source)
			# now use it to fetch the actual keywords from the query string
			unless @page_referrer.query.nil?
				query_parameters = CGI.parse(@page_referrer.query)
				if query_parameters.has_key?(keyword_parameter)
					return query_parameters[keyword_parameter].to_s
				end
			end
		end
	end

	# is_referrer? checks if referrer is a search engine, returns nil if so and the host if not
	def is_referrer?
		# is a referrer if page_referrer is not nil AND is_search_engine is FALSE
		unless is_search_engine?
			return @page_referrer.host
		end
	end
	
end


