class HeroesController < ApplicationController

	def index
		@heroes = Hero.display_heroes
	end

	def show
		@hero = Hero.find_by(id:params[:id])
        if @hero.nil?
            flash[:error] = 'Hero does not exist'
            return redirect_to heroes_path
        end
	end
end
