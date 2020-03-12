=begin

	Author: Brandon Stenhouse
	Date: 04/02/20
	Version: 0.1
  Project: Office365 Automation
  File: main.rb
	Purpose: This Ruby script is the main control for this program,
	this will load the Office365 API call, raise a ticket within SNOW and
	exacute the configuration on a Cisco ASA

=end

require_relative 'office'
#require_relative 'memory'
#require_relative 'snow'
#require_relative 'ssh'

GUID = "ab1a058f-8756-4708-8866-7b811618fb97"

o365 = Office365.new GUID

puts o365.getO365.each { |ip| "#{ip.to_string}/#{ip.prefix}"}
