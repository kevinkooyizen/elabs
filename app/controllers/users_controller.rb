require 'open-uri'
class UsersController < ApplicationController
    include UsersHelper
    before_action(except: [:new, :create]) do
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

    def update
        @user = current_user
        @occupations = get_occupation_list
        render 'update'
    end

    def edit

    end


    def show
        user_id = 100893614
        @user = JSON.parse open("https://api.opendota.com/api/players/#{user_id}").read
        @user_winlose = JSON.parse open("https://api.opendota.com/api/players/#{user_id}/wl").read
        if @user_winlose["win"] != 0 || @user_winlose["lose"] != 0
            @user_winrate = 100 * @user_winlose["win"]/(@user_winlose["win"] + @user_winlose["lose"])
        else
            @user_winrate = 0
        end
    end



end
