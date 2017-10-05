class TeamsController < ApplicationController
	def index
		@teams = JSON.parse open("https://api.opendota.com/api/teams").read
	end

	def show
		@team = Team.find(params[:id])
		api = Dota.api
	end

	def new
		@team = Team.new
	end

	def create
		@team = Team.new(team_params)
		if @team.save
			flash[:successfull] = "Congratulations, you have created a team. Enjoy your game..."
			redirect_to edit_team_path	
		else
			flash[:failure]= "You have failed to create a team. Please try again."
			redirect_to @team
		end
	end

	def edit
		@team = Team.find(params[:id])
	end

	def update
		@team = Team.find(params[:id])
		if @team.update(team_params)
			flash[:success] = "Updated the team details successfully."
			redirect_to edit_team_path
		else
			flash[:failure] = "You have failed to update the team details. Please try again."
			redirect_to edit_user_path
		end
	end

	def destroy
		@team = Team.find(params[:id])
		@team.status = false
		if @team.save
			flash[:success] = "You have removed your account. Hope to see you again."
			redirect_to root_path #can be change
		else
			flash[:failure] = "You have failed to remove your account from elabs. Please try again."
			redirect_to edit_path #can be change
		end
	end

 	private

 	def team_params
 		params.require(:team).permit(:name, :sponsor, :coach, :manager, :country, :status, :dota2_team_id)
 	end
end
