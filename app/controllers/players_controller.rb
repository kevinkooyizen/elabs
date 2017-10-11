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
        # if !signed_in?
        #     @players = Player.all.order('mmr desc').page params[:page]
        # elsif current_user.occupation == 'player'
        # #     recommendation here
        # else
        #     @players = Player.all.order('mmr desc').page params[:page]
        # end

        @players = Player.all.order('mmr desc').page params[:page]
        

        return render 'index'
    end

    def show
        # @player = Player.find_by(id: params[:id])
        # @user = @player.user
        # @user.store
        # render 'show'

        player = Player.find_by(id:params[:id])
        if player.present?
            # redirect to user show because both view should display the content
            return redirect_to user_path(player.user.id)
        else
            flash[:error] = 'Player not exists.'
            return redirect_to :back
        end
    end

    def search
        # return the params that user searched for back to view
        @params = search_params.to_h

        @players = Player.player_search(persona_name:search_params[:persona_name],
                                        real_name: search_params[:real_name],
                                        state: search_params[:state],
                                        mmr_lower_range: search_params[:mmr_lower_range],
                                        mmr_upper_range: search_params[:mmr_upper_range]).order('mmr desc').page params[:page]

        return render 'index'
    end

    def teams_recommendation
        if !signed_in?
            flash[:notice] = 'Please sign in to perform to this action'
            return redirect_to players_path
        end

        player = Player.find_by(id:params[:id])

        if !player.present?
            flash[:error] = 'Player does not exist!'
            return redirect_to players_path
        end

        # this is an array of activerecord, use the [0...N] method to get the topN players by similarity
        @teams = Kaminari.paginate_array(player.teams_sorted_by_similarity).page(params[:page])

        #     choose a view file to render the players

    end

    def edit

    end

    def update

    end

    def become_player
        player = Player.new(user_id: params[:id])
        user = User.find_by(id: params[:id])

        if user.nil?
            flash[:error] = 'User does not exist'
            return redirect_to :back
        end


        if user.real_name.present?
            player.real_name = user.real_name
        end
        if user.persona_name.present?
            player.persona_name = user.persona_name
        end
        player.last_login = Date.today

        player.save!
        return redirect_to user_path(player.user.id)
    end

    private

    def search_params
        params.require(:search).permit(:persona_name,
                                       :real_name, :state,
                                       :mmr_lower_range,
                                       :mmr_upper_range)
    end

end
