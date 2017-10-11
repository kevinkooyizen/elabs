class EnquiriesController < ApplicationController
	
	def enquiries
		@enquiry = Enquiry.new(team_id: params[:id], user_id: current_user.id, user_uid: current_user.uid, status: "team")
		if @enquiry.save 
		     redirect_to team_path
		else
			flash[:failure] = "Sorry, please try again later."
			redirect_to team_path
		end
	end

	def teams_enquiries
		@team_enquiry = Enquiry.new(user_id: params[:id], user_uid: params[:user_uid], team_id: params[:team_id], status: "user")
		if @team_enquiry.save
			redirect_to user_path
		else
			flash[:failure] = "Sorry, please try again later."
			redirect_to user_path	
		end
	end
end
