class PlayersController < ApplicationController
    include SearchHelper

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
        @players = Player.all.order('mmr desc')
        render 'index'
    end

    def show
        @player = Player.find(params[:id])
        render 'show'
    end

    def search
        # return the params that user searched for back to view
        @params = search_params.to_h

        @players = Player.player_search(persona_name:search_params[:persona_name],
                                        real_name: search_params[:real_name],
                                        state: search_params[:state],
                                        mmr_lower_range: search_params[:mmr_lower_range],
                                        mmr_upper_range: search_params[:mmr_upper_range]).order('mmr desc')

        return render 'index'
    end

    def edit

    end

    def update

    end

    private

    def search_params
        params.require(:search).permit(:persona_name,
                                       :real_name, :state,
                                       :mmr_lower_range,
                                       :mmr_upper_range)
    end

end
