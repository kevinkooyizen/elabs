class HeroesController < ApplicationController

	def index
		@heroes = Hero.display_heroes
	end

	def show
		@hero = Hero.find(params[:id])
	end
end
