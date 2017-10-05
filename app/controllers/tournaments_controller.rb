class TournamentsController < ApplicationController

	def index
		tour = Dota.api
		league_id = 5364
		match_history_id = 3483429548
		@tournaments = tour.get("IDOTA2Match_570", "GetLeagueListing", league_id: league_id )
		@matches = JSON.parse open("https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/?key=#{ENV["STEAM_KEY"]}").read
		byebug
		@team = JSON.parse open("https://api.sportradar.us/dota2-v1/us/teams/sr:competitor:262739/results.json?api_key=#{ENV["RADAR_KEY"]}").read
	end	

	def new
		@tournament = Tournament.new
	end

	def create
		@tournament = Tournament.new(tournament_params)
		if @tournament.save
			flash[:success] = "Congratulations, you have created a tournament successfully."
			redirect_to root_path 
		else
			flash[:failure] = "Sorry, you have failed to create a tournament. Please try again."
			redirect_to root_path
		end
	end

	def edit
		@tournament = Tournament.find(params[:id])
	end

	def update
		@tournament = Tournament.find(params[:id])
		if @tournament.update(tournament_params)
			flash[:success] = "You have updated tournament details successfully"
			redirect_to root_path
		else
			flash[:failure] = "Sorry, you have failed to update the tournament details. Please try again."
		end
	end

	private
	def tournament_params
		params.require(:tournament).permit(:name, :start, :end, :game)
	end
end
