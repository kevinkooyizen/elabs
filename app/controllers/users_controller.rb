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
        @user = JSON.parse open("https://api.opendota.com/api/players/#{current_user.uid}").read
        if !@user["profile"].nil?
            @user_winlose = JSON.parse open("https://api.opendota.com/api/players/#{current_user.uid}/wl").read
            if @user_winlose["win"] != 0 || @user_winlose["lose"] != 0
                @user_winrate = (100 * @user_winlose["win"].to_f/(@user_winlose["win"].to_f + @user_winlose["lose"].to_f)).round(2)
            else
                @user_winrate = 0
            end
            top_heroes = []
            @user_heroes = JSON.parse open("https://api.opendota.com/api/players/#{current_user.uid}/heroes").read
            @user_heroes[0..9].each do |hero|
                # storing heroes into top heroes
                if top_heroes.count < 3
                    top_heroes << hero
                end
                # arranging top heroes based on winrate
                top_heroes.sort_by! do |current|
                    current["win"]*1000000/current["games"].to_i
                end
                if top_heroes.count == 3
                    top_heroes.each_with_index do |top, index|
                        top_heroes_winrate = top["win"]*1000000/top["games"].to_i
                        heroes_winrate = hero["win"]*1000000/hero["games"].to_i
                        if heroes_winrate > top_heroes_winrate && !top_heroes.include?(hero)
                            top_heroes.delete_at(index)
                            top_heroes << hero
                        end
                    end
                end
            end
            top_heroes_id = []
            top_heroes.each do |select|
                top_heroes_id << select["hero_id"].to_i
            end
            heroes = JSON.parse open("https://api.opendota.com/api/heroes").read
            @top_heroes_names = []
            heroes.each do |info|
                if top_heroes_id.include?(info["id"])
                    @top_heroes_names << info["name"].match(/npc_dota_hero_(\w+)/)[1]
                end
            end
            # sorting top heroes in ascending order winrate
            top_heroes.sort_by! do |current|
                current["win"]*1000000/current["games"].to_i
            end
            @top_hero = top_heroes[-1]
            @top_hero_winrate = (100*top_heroes[-1]["win"].to_f/top_heroes[-1]["games"].to_f).round(2)
            @user_matches = JSON.parse open("https://api.opendota.com/api/players/#{current_user.uid}/matches").read
            @user_matches.select! do |item|
                item["hero_id"] == top_heroes[-1]["hero_id"].to_i
            end
            @top_hero_kills = 0
            @top_hero_deaths = 0
            @top_hero_assists = 0
            @user_matches.each do |x|
                @top_hero_kills += x["kills"].to_f/top_heroes[-1]["games"].to_f
                @top_hero_deaths += x["deaths"].to_f/top_heroes[-1]["games"].to_f
                @top_hero_assists += x["assists"].to_f/top_heroes[-1]["games"].to_f
            end
            Hero.all.each do |item|
                if @top_hero["hero_id"].to_i == item.api_id
                    @top_hero_name = item.name
                end
            end
            @won = JSON.parse open("https://api.opendota.com/api/players/100893614/matches/?win=1").read
        end
    end

    private

    def user_update_params
        params.require(:user).permit(:occupation, :country, :state, :"birthday(1i)", :"birthday(2i)", :"birthday(3i)")
    end


end
