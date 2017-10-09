class StaticController < ApplicationController

  def home
    @user = User.first

    @player = Player.first

    @team = Team.first
  end

end
