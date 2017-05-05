require 'httparty'
require 'json'

class Kele
	include HTTParty

	attr_reader :auth_token

	def initialize(email, password)
		@bloc_API_url = "https://www.bloc.io/api/v1"
		response = self.class.post("https://www.bloc.io/api/v1/sessions", body: {"email": email, "password": password})

		if response.success?
			@auth_token = response["auth_token"]
		else
			puts response.body, response.code, response.message
			puts "\nINSPECT RESPONSE HEADERS:"
			puts response.headers.inspect
		end
	end

	def get_me
		response = self.class.get("https://www.bloc.io/api/v1/users/me", headers: {"authorization" => @auth_token})

		JSON.parse(response.body)
	end
end
