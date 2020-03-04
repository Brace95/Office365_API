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

=begin
O365_url: The path to the Office365 API (unchanged part)
@O365_path: The completed path with type and GUID to Office365 API
@O365_Services: The output from the API call in JSON format
=end

	O365_url = "https://endpoints.office.com/endpoints/worldwide"
	@O365_path
	@O365_Services

=begin

Name:
	initialize
Arguments:
	- guid: A Generated GUID to be used as the client request ID to Office365 API
Return:
	None
Description:
	Setup the class and make the API call.

=end
	def initialize guid
		@O365_path = URI.parse "#{O365_url}?format=json&clientrequestid=#{guid}"
		@O365_Services = Array.new
		apiCall()
	end

=begin

Name:
	getO365
Arguments:
	- type <subnet|url>: To control the return type from the function
	- service <sting|id>: To control the search of the function
Return:
	Array of Subnets or URLs
Description:
	Parse the API return and return a array of IPs or URLs on all services or a
	specific service.

=end
	def getO365 type="subnet", service=nil
		rt = Array.new
		@O365_Services.each do |s|
			if service.nil? || s["serviceArea"].match(service) || s["id"] == service then
				if type.match "subnet" && s["ips"] then
					s["ips"].each do |ip|
						temp_ip = IPAddr.new ip
						rt.push temp_ip if temp_ip.ipv4?
					end
				end
				if type.match "url" && s["urls"] then
					s["urls"].each {|url| rt.push url}
				end
			end
		end

		return rt
	end

	private

=begin

Name:
	apiCall
Arguments:
	None
Return:
	None
Description:
	Create and complete the GET request, save the results to
	@O365_Services JSON parsed

=end
	def apiCall
		# Build Request
		req = Net::HTTP::Get.new @O365_path.request_uri
		http = Net::HTTP.new @O365_path.host, @O365_path.port
		http.use_ssl = true

		# Make the request
		puts "Making API call..."
		res = http.request req
		if res.code == "200"
			@O365_Services = JSON.parse res.body
			puts "Making API call..."
		else
			raise IOError, "Invaild response from Office365 API: #{res.code} - #{res.body}"
		end

	end

end
