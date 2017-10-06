class TeamsController < ApplicationController
	def index
		@teams = Team.order(rating: :desc).page params[:page]
		@pros = JSON.parse open("https://api.opendota.com/api/proPlayers").read
	end

	def show
		@team = Team.find(params[:id])
		@pros = JSON.parse open("https://api.opendota.com/api/proPlayers").read
		# @teams = JSON.parse open("https://api.opendota.com/api/teams").read
		# @teams.select do |item|
		# 	if item["name"] == @team.name
		# 		@teaminfo = item
		# 	end
		# end
		# @team_roster = []
		# @pros.select do |item|
		# 	if item["team_name"] == @team.name && item["locked_until"] != 0
		# 		@team_roster << item
		# 	end
		# end
		# if @teaminfo["wins"] != 0 && @teaminfo["losses"] != 0
		# 	@team_winrate = 100 * @teaminfo["wins"]/(@teaminfo["wins"] + @teaminfo["losses"])
		# else
		# 	@team_winrate = nil
		# end
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
			redirect_to team_path(@team)
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
