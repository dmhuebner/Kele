require 'httparty'

class Kele
	include HTTParty

	def initialize(email, password)
		@bloc_API_url = "https://www.bloc.io/api/v1"
		response = self.class.post("https://www.bloc.io/api/v1/sessions", body: {"email": email, "password": password})

		if response.success?
			@auth_token = response
		else
			puts response.body, response.code, response.message
			puts "\nINSPECT RESPONSE HEADERS:"
			puts response.headers.inspect
		end
	end
end
