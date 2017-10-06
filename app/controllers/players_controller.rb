class PlayersController < ApplicationController

    before_action(only:[:edit, :update, :destroy]) do
        continue = true
        if !signed_in?
            flash[:alert] = 'Please sign in to perform this action.'
            redirect_to root_path
            continue = false
        end
        if continue && !is_resource_owner?(resource_user_id: params[:id].to_i)
            flash[:alert] = 'You do not have the permission to perform this action.'
            redirect_to root_path
        end
    end

    def index
        @players = Player.all
        render 'index'
    end

    def show
        @player = Player.find(params[:id])
        render 'player'
    end

    def search

    end

    def edit

    end

    def update

    end

    private

    def search_params
        
    end

end
