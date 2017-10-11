class StaticController < ApplicationController

  def home
    # @home_user = User.first
    @player = Player.first
    @team = Team.first

    if signed_in?
      @user = current_user
      @user = ApiExtension::OpenDota.get_player_profile(uid: current_user.uid)
    else
      @user = nil
    end


    @tournaments = Tournament.display_tournaments.page(params[:page]).per(3)
  end

end
