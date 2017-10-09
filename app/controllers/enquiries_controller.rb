class EnquiriesController < ApplicationController
	
	def enquiries
		@enquiry = Enquiry.new(team_id: params[:id], user_id: current_user.id, user_uid: current_user.uid)
		if @enquiry.save 
		     redirect_to team_path
		else
			flash[:failure] = "Sorry, please try again later."
			redirect_to team_path
		end
	end
end
