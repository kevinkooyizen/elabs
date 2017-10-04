require 'open-uri'
class UsersController < ApplicationController
    include UsersHelper
    before_action(except: [:new, :create]) do
        if !signed_in?
            flash[:alert] = 'Please sign in to perform this action.'
            return redirect_to root_path
        elsif !is_resource_owner?(params[:id])
            flash[:alert] = 'You do not have the permission to perform this action.'
            return redirect_to root_path
        end
    end

    def new
    end

    def create
    end

    def update

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
