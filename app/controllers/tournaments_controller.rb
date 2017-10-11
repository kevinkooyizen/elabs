class TournamentsController < ApplicationController
	include SearchHelper
	def index
		@tournaments = Tournament.display_tournaments.page(params[:page]).per(8) 
	end	

	def search
		@tournaments = Tournament.display_tournaments.page(params[:page]).per(8)
		params_valid = true
		start_date = PseudoDate.new(search_params[:"start(1i)"],search_params[:"start(2i)"],search_params[:"start(3i)"])
        end_date = PseudoDate.new(search_params[:"end(1i)"],search_params[:"end(2i)"],search_params[:"end(3i)"])
        if !start_date.valid?
            flash[:error] = 'Invalid date!'
            params_valid = false
        end

        if !end_date.valid?
            flash[:error] = 'Invalid date!'
            params_valid = false
        end

        if params_valid
            @tournaments = Tournament.tournament_search(name: search_params[:name],
                                                     description: search_params[:description],
                                                     start: start_date.to_string,
                                                     end_date: end_date.to_string,
                                                     game: search_params[:game]).page(params[:page]).per(8)
        end

        # this is to return the params keyed in by user when the page is refreshed
        # can be omitted if ajax is implemented
        @params = search_params.to_h
        @params[:start] = start_date.valid? ? start_date.to_date : Date.today
        @params[:end_date] = end_date.valid? ? end_date.to_date : Date.today

        render 'index'
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
		@tournament = Tournament.find_by(id:params[:id])
        if @tournament.nil?
            flash[:error] = 'Tournament does not exist.'
            return redirect_to tournaments_path
        end
	end

	def update
		@tournament = Tournament.find_by(id: params[:id])
        if @tournament.nil?
            flash[:error] = 'Tournament does not exist.'
            return redirect_to tournaments_path
        end
		if @tournament.update(tournament_params)
			flash[:success] = "You have updated tournament details successfully"
			redirect_to root_path
		else
			flash[:failure] = "Sorry, you have failed to update the tournament details. Please try again."
		end
	end

	def destroy
		@tournament = Tournament.find_by(id: params[:id])
        if @tournament.nil?
            flash[:error] = 'Tournament does not exist.'
            return redirect_to tournaments_path
        end
		@tournament.status = false
		if @team.save
			flash[:success] = "You have removed your tournament. Hope to see you again."
			redirect_to root_path #can be change
		else
			flash[:failure] = "You have failed to remove your tournament start elabs. Please try again."
			redirect_to edit_path #can be change
		end
	end
	
	private
	def tournament_params
		params.require(:tournament).permit(:name, :description, :tournament_url, :start, :end_date, :game, :status)
	end

	def search_params
        params.require(:search).permit(:name, :description, :"start(1i)", :"start(2i)", :"start(3i)", :"end(1i)", :"end(2i)", :"end(3i)", :game)
    end
end
