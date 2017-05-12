require 'httparty'
require 'json'
require_relative 'roadmap'

class Kele
	include HTTParty
	include Roadmap

	attr_reader :auth_token

	def initialize(email, password)
		@bloc_API_url = api_url
		response = self.class.post("#{api_url}sessions", body: {"email": email, "password": password})

		if response.success?
			@auth_token = response["auth_token"]
		else
			puts response.body, response.code, response.message
			puts "\nINSPECT RESPONSE HEADERS:"
			puts response.headers.inspect
		end
	end

	def get_me
		response = self.class.get("#{api_url}users/me", headers: {"authorization" => @auth_token})
		@user_data = JSON.parse(response.body)

		@user_data.each do |d|
			puts "#{d} \n\n"
		end
	end

	def get_mentor_availability(mentor_id)
		response = self.class.get("#{api_url}mentors/#{mentor_id}/student_availability", headers: {"authorization" => @auth_token})
		@mentor_availability = JSON.parse(response.body)

		@mentor_availability.each do |d|
			puts "\n"
			d.each do |i|
				puts "#{i} \n"
			end
		end
	end

	def get_messages
		response = self.class.get("#{api_url}message_threads", headers: {"authorization" => @auth_token})
		@message_threads = JSON.parse(response.body)
	end

	#### create_message: Parameters
	# sender = email string
	# recipient_id = integer
	# stripped_text = string
	# subject = string (optional)
	# token = thread token string (optional)
	def create_message(sender, recipient_id, stripped_text, subject = nil, token = nil)
		if token == nil
			response = self.class.post("#{api_url}messages", body: {"sender": sender, "recipient_id": recipient_id, "subject": subject, "stripped-text": stripped_text}, headers: {"authorization" => @auth_token})
		else
			response = self.class.post("#{api_url}messages", body: {"sender": sender, "recipient_id": recipient_id, "token": token, "subject": subject, "stripped-text": stripped_text}, headers: {"authorization" => @auth_token})
		end

		if response.success?
			"Your message was sent successfully"
		else
			puts response.body, response.code, response.message
			puts "\nINSPECT RESPONSE HEADERS:"
			puts response.headers.inspect
		end
	end

	private
		def api_url
			"https://www.bloc.io/api/v1/"
		end
end
