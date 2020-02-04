=begin

	Author: Brandon Stenhouse
	Date: 04/02/20
	Version: 0.1
	Purpose: This Ruby script is to access the Office365 API to collect
	all IP and URLs that Office365 use.

=end

require 'net/http'
require 'net/https'
require 'uri'
require 'json'
require 'ipaddr'

class Office365

	@@O365_url = "https://endpoints.office.com/endpoints/worldwide"
	@Call
	@Subnet
	@Urls

	def initialize guid, format

		@Call = URI.parse "#{@@O365_url}?format=#{format}&clientrequestid=#{guid}"
		initClass()
		apiCall()
	end

	def getO365Subnets
		return @Subnet.uniq.sort
	end

	def getO365Urls
		return @Urls.uniq.sort
	end

	def updateO365
		initClass()
		apiCall()
	end

	private

	def initClass
		@Subnets = Array.new
		@Urls = Array.new
	end

	def apiCall
		# Build Request
		req = Net::HTTP::Get.new @Call.request_uri
		http = Net::HTTP.new @Call.host, @Call.port
		http.use_ssl = true

		# Make the request
		res = http.request req
		if res.code == "200"
			parseResponse JSON.parse res.body
		else
			raise IOError, "Invaild response from Office365 API: #{res.code} - #{res.body}"
		end

	end

	def parseResponse json
		temp_urls = Array.new
		temp_ips = Array.new
		json.each do |e|
			e["urls"].each { |url| temp_urls.push(url)} if e["urls"]
			if e["ips"] then
				e["ips"].each do |ip|
					temp_ips.push(ip) if IPAddr.new(ip).ipv4?()
				end
			end
		end
		@Urls = temp_urls.uniq.sort
		@Ips = temp_ips.uniq.sort
	end

end
