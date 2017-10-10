class StaticController < ApplicationController

  def home
    @home_user = User.first
    @player = Player.first
    @team = Team.first

    @tournaments = Tournament.display_tournaments.page(params[:page]).per(3)
  end

end
