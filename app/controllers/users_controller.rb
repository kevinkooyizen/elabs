class UsersController < ApplicationController
    include UsersHelper
    before_action(except: [:new, :create, :show]) do
        continue = true
        if !signed_in?
            flash[:alert] = 'Please sign in to perform this action.'
            redirect_to root_path
            continue = false
        end
        # byebug
        if continue && !is_resource_owner?(resource_user_id: params[:id].to_i)
            flash[:alert] = 'You do not have the permission to perform this action.'
            redirect_to root_path
        end
    end

    def new
    end

    def create
    end

    def edit
        @user = current_user
        @occupations = get_occupation_list
        render 'edit'
    end

    def update
        @user = current_user
        @user.country = user_update_params[:country]
        @user.state = user_update_params[:state]
        @user.occupation = user_update_params[:occupation]
        @user.birthday = Date.new(user_update_params[:"birthday(1i)"].to_i, user_update_params[:"birthday(2i)"].to_i, user_update_params[:"birthday(3i)"].to_i)
        if @user.save
            redirect_to user_path(@user)
        else
            flash[:error] = @user.errors.messages
            redirect_to edit_users_path(@user)
        end
    end

    def show
        user = User.find_by(id:params[:id])


        if !user.present?
            flash[:error] = 'User not exists.'
            return redirect_back fallback_location: users_path
        end

        @user = ApiExtension::OpenDota.get_player_profile(uid: user.uid)
        # if @user["profile"].nil?
        #     @user["profile"]["last_login"] = "2017-10-04T15:38:36.695Z"
        # end
        @var = user
        @var.store
        @teams = Enquiry.where(user_id: params[:id], status: "user")

        if signed_in?
            @team = Team.find_by(user_id: current_user.id)
        else
            @team = nil
        end

        # if @team.nil?
        #     if !Player.find_by(user_id: User.find_by(id:params[:id]).id).nil?
        #         if !Player.find_by(user_id: User.find_by(id:params[:id]).id).team_id.nil?
        #             @team = Team.find_by(id:Player.find_by(user_id: User.find_by(id:params[:id]).id).team_id)
        #         end
        #     end
        # end
        @player = Player.find_by(user_id: user.id)
        @heroes = @var.top_heroes[0..2].map {|x| HeroApi.new(@var.uid, x)}
    end

    private

    def user_update_params
        params.require(:user).permit(:occupation, :country, :state, :"birthday(1i)", :"birthday(2i)", :"birthday(3i)")
    end

end
