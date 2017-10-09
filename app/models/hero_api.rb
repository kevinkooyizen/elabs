require 'open-uri'

class HeroApi
  attr_reader :hero_id, :hero_name, :games, :win, :kills, :deaths, :assists, :heroes_gpm, :heroes_xpm, :heroes_items, :heroes_avg_gpm, :heroes_avg_xpm
  def initialize(uid, hash, matches_load_limit = 5)
    @uid = uid
    
    @matches_load_limit = matches_load_limit
    @hero_id = hash["hero_id"]
    @hero_name = Hero.find_by(api_id: @hero_id).name
    @games = hash["games"]
    @win = hash["win"]
    @kills = 0
    @deaths = 0
    @assists = 0
    @heroes_gpm = []
    @heroes_xpm = []
    @heroes_items = []
    @heroes_avg_gpm = 0
    @heroes_avg_xpm = 0
    
    calculate_hero_kda
    calculate_hero_gpm_xpm
  end

  def winrate
    (100 * @win.to_f/ @games.to_f).round(2)
  end

  def kills_rate
    @kills / @games
  end

  def deaths_rate
    @deaths / @games
  end

  def assists_rate
    @assists / @games
  end

  def matches
    @matches[0..4]
  end

  private

  def hero_matches
    @matches ||= fetch_hero_matches
  end

  def calculate_hero_kda
    hero_matches.each_with_index do |match, index|
      @kills += match["kills"] 
      @deaths += match["deaths"] 
      @assists += match["assists"]

        # https://wiki.teamfortress.com/wiki/WebAPI/GetMatchDetails#Player_Slot
        # less than 50 => user in radiant
        # more than 50 => user in dire

        # less than 50 && user in radiant => won
        # more than 50 && user not in radiant => won
        if index < 5
          match["user_win"] = (match["player_slot"] < 50) == match["radiant_win"]
        
          match_data = JSON.parse open("https://api.steampowered.com/IDOTA2Match_570/GetMatchDetails/V001/?match_id=#{match["match_id"]}&key=#{ENV["STEAM_KEY"]}").read
          
          data = match_data["result"]["players"].find do |data|
            data["account_id"] == @uid.to_i
          end

            
          match["gold_per_min"] = data["gold_per_min"]
          match["xp_per_min"] = data["xp_per_min"]

          match["player_match_items"] = [data["item_0"],data["item_1"],data["item_2"],data["item_3"],data["item_4"],data["item_5"]].reject { |x| x == 0 }.map do |item_id|
            Item.find_by(api_id: item_id).api_name
          end
        end
        # @heroes_avg_gpm += data["gold_per_min"]
        # @heroes_avg_xpm += data["xp_per_min"]
      
    end
    # @heroes_avg_gpm = @heroes_avg_gpm/(hero_matches.count)
    # @heroes_avg_xpm = @heroes_avg_xpm/(hero_matches.count)    
  end

  def fetch_hero_matches
    JSON.parse open("https://api.opendota.com/api/players/#{@uid}/matches?hero_id=#{@hero_id}").read
  end  
end