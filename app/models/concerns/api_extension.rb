require 'open-uri'
module ApiExtension
    class OpenDota
        def self.get_player_profile(uid:nil)
            if uid.nil?
                self.missing_params_error
            else
                JSON.parse open("https://api.opendota.com/api/players/#{uid}").read
            end
        end

        def self.get_player_heroes(uid: nil)
            if uid.nil?
                self.missing_params_error
            else
                JSON.parse open("https://api.opendota.com/api/players/#{uid}/heroes").read
            end
        end

        def self.get_player_hero_matches(uid: nil, hero_id: nil)
            if uid.nil? || hero_id.nil?
                self.missing_params_error
            else
                JSON.parse open("https://api.opendota.com/api/players/#{uid}/matches?hero_id=#{hero_id}").read
            end
        end

        def self.get_player_winlose(uid: nil)
            if uid.nil?
                self.missing_params_error
            else
                JSON.parse open("https://api.opendota.com/api/players/#{uid}/wl").read
            end
        end

        def self.get_pro_players
            JSON.parse open("https://api.opendota.com/api/proPlayers").read
        end

        def self.get_all_heroes
            JSON.parse open("https://api.opendota.com/api/heroes").read
        end

        def self.get_all_teams
            JSON.parse open("https://api.opendota.com/api/teams").read
        end

        def self.missing_params_error
            {'error':'Missing params'}
        end
    end
end