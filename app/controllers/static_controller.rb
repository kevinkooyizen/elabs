class StaticController < ApplicationController

  def home
    @user = User.first
    @player = Player.first
    @team = Team.find(17)

    @tournaments = Tournament.display_tournaments.page(params[:page]).per(3)
  end

end
