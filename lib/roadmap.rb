module Roadmap
	def get_roadmap(roadmap_id)
		response = self.class.get("#{api_url}roadmaps/#{roadmap_id}", headers: {"authorization" => @auth_token})

		@roadmap = JSON.parse(response.body)
	end

	def get_checkpoint(checkpoint_id)
		response = self.class.get("#{api_url}checkpoints/#{checkpoint_id}", headers: {"authorization" => @auth_token})

		@checkpoint = JSON.parse(response.body)
	end

	#### create_checkpoint: Parameters
	# checkpoint_id = integer
	# assignment_branch = string - GitHub branch for assignment
	# assignment_commit_link = string - GitHub commit link for assignment
	# subject = string (optional)
	# token = thread token string (optional)
	def create_checkpoint(checkpoint_id, assignment_branch, assignment_commit_link, comment)
		user_enrollment_id = self.get_me["current_enrollment"]["id"]
		response = self.class.post("#{api_url}checkpoint_submissions", body: {"assignment_branch": assignment_branch, "assignment_commit_link": assignment_commit_link, "checkpoint_id": checkpoint_id, "comment": comment, "enrollment_id": user_enrollment_id}, headers: {"authorization" => @auth_token})

		@new_checkpoint = JSON.parse(response.body)
	end

	private
		def api_url
			"https://www.bloc.io/api/v1/"
		end
end
