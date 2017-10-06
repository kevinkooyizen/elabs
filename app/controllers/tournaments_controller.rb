class TournamentsController < ApplicationController
	
	def index
		@tournaments = Tournament.display_tournaments
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

	def destroy
		@tournament = Tournament.find(params[:id])
		@tournament.status = false
		if @team.save
			flash[:success] = "You have removed your tournament. Hope to see you again."
			redirect_to root_path #can be change
		else
			flash[:failure] = "You have failed to remove your tournament from elabs. Please try again."
			redirect_to edit_path #can be change
		end
	end
	
	private
	def tournament_params
		params.require(:tournament).permit(:name, :description, :tournament_url, :start, :end_date, :game, :status)
	end
end
