require 'open-uri'
class User < ApplicationRecord
    include Clearance::User
    has_one :player
    has_one :role
    has_many :sponsors
    has_many :teams
    attr_reader :stats

    BIT_CONVERSION = 76561197960265728

    def self.create_from_omniauth(uid: nil, real_name: 'anonymous', persona_name:'anonymous', country: nil, provider: nil, email:nil)
        user = User.new
        # TODO need to confirm the flow of filling in email
        user.email = email
        user.uid = User.change_uid_to_32_bit uid_64_bit: uid
        user.provider = provider
        user.real_name = real_name
        user.persona_name = persona_name
        user.country = country
        user.password = SecureRandom.hex(10)
        user.save
        return user
    end

    # def self.find_by_uid(uid_64bit: nil)
    #     self.find_by uid: self.change_uid_to_32bit(uid_64bit)
    # end

    # uid from steam oauth is in 64bit, convert it to 32bit as most of the third party api are using 32bit
    def self.change_uid_to_32_bit(uid_64_bit: nil)
        (uid_64_bit.to_i - self.bit_conversion).to_s
    end

    def self.change_uid_to_64_bit(uid_32_bit: nil)
      (uid_32_bit.to_i + self.bit_conversion).to_s
    end

    def profile_exist?
        user = JSON.parse open("https://api.opendota.com/api/players/#{self.uid}").read
        if !user["profile"].nil?
            return true
        else
            return false
        end
    end

    def winrate
        user_winlose = JSON.parse open("https://api.opendota.com/api/players/#{self.uid}/wl").read
        if user_winlose["win"] != 0 || user_winlose["lose"] != 0
            return (100 * user_winlose["win"].to_f/(user_winlose["win"].to_f + user_winlose["lose"].to_f)).round(2)
        else
            return 0
        end
    end

    def top_heroes
        user_heroes = JSON.parse open("https://api.opendota.com/api/players/#{self.uid}/heroes").read
        top = user_heroes[0..9]
        if self.winrate != 0
            top.sort_by! do |item|
                100* item["win"]/item["games"]
            end
        end
        top.reverse!
    end

    def top_heroes_names
        names = []
        self.top_heroes.each do |item|
            hero = Hero.find_by(api_id: item["hero_id"])
            names << hero.name
        end
        names
    end

    def top_heroes_npc_names
        names = []
        self.top_heroes.each do |item|
            hero = Hero.find_by(api_id: item["hero_id"])
            names << hero.api_npc_name
        end
        names
    end

    def top_hero
        self.top_heroes[0]
    end

    def top_hero_name
        Hero.find_by(api_id: self.top_hero["hero_id"]).name
    end

    def top_hero_winrate
        (100*self.top_hero["win"].to_f/self.top_hero["games"].to_f).round(2)
    end

    def top_hero_matches
        (JSON.parse open("https://api.opendota.com/api/players/#{self.uid}/matches?hero_id=#{self.top_hero["hero_id"].to_i}").read)
    end

    def top_hero_kills
        kills = 0
        self.top_hero_matches.each do |x|
            kills += x["kills"]
        end
        if kills != 0
            kills/self.top_hero["games"]
        end
    end

    def top_hero_deaths
        deaths = 0
        self.top_hero_matches.each do |x|
            deaths += x["deaths"]
        end
        if deaths != 0
            deaths/self.top_hero["games"]
        end
    end

    def top_hero_assists
        assists = 0
        self.top_hero_matches.each do |x|
            assists += x["assists"]
        end
        if assists != 0
            assists/self.top_hero["games"]
        end
    end

    def match_win?(match)
        win = false
        won = JSON.parse open("https://api.opendota.com/api/players/100893614/matches/?win=1&hero_id=#{self.top_hero["hero_id"].to_i}").read
        won.each do |item|
            if item["match_id"] == match["match_id"]
                win = true
            end
        end
        win
    end

    private

    def self.bit_conversion
        BIT_CONVERSION
    end

end
