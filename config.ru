# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

require "open-uri"

require "uri"

require "net/http"

require "openssl"
	
run Rails.application
