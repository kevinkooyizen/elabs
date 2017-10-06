class StaticController < ApplicationController

  def home
    @user = User.find_by(id: 2)

    @player = Player.find_by(id: 1)

    @team = Team.find_by(id: 1)

  end

end
