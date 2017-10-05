class Player < ApplicationRecord
    belongs_to :user
    belongs_to :team

    attr_reader :stats

    def self.persona_name(persona_name=nil)
        if persona_name.present?
            joins(:user).where('users.persona_name ilike ?', "%#{persona_name}%")
        else
            all
        end
    end

    def self.real_name(real_name=nil)
        if persona_name.present?
            joins(:user).where('users.real_name ilike ?', "%#{real_name}%")
        else
            all
        end
    end

    def self.state(state=nil)
        if state.present?
            joins(:user).where("state ilike ?", "%#{state}%")
        else
            all
        end
    end

    def self.player_search(persona_name: nil, real_name: nil, state: nil, mmr_lower_range: self.min_mmr, mmr_upper_range: self.max_mmr)
        # initialize an array to store the players ids for query later
        players_ids = []
        players = self.persona_name(persona_name).real_name(real_name).state(state).includes(:user)

        if players.present?
            players.each do |player|
                player.get_player_stats!
                continue if player.stats.solo_mmr.nil? or player.stats.nil?

                if player.stats.solo_mmr >= mmr_lower_range && player.stats.solo_mmr <= mmr_upper_range
                    players_ids << player.id
                end
            end
        end
        # you need to invoke the get_player_stats! method to get the stats again as the data couldn't persist in the action relation object
        where("id in (?)", players_ids)
    end

    # invoke dota api to save the stats data to @stats
    def get_player_stats!
        api_result = JSON.parse open("https://api.opendota.com/api/players/#{self.user.uid}").read
        @stats = parse_player_stats(api_result: api_result)
    end
    
    # private

    # use a better structure to keep the stats
    Player_stats = Struct.new(:id,
                              :last_login_date,
                              :solo_mmr,
                              :win_lose,
                              :persona_name,
                              :avatar,
                              :profile_url,
                              :country) do
        def last_login
            Date.strptime(last_login_date, '%Y-%m-%dT%H:%M:%S')
        end

        def show_attributes
            self.each_pair do |k, v|
                k = k.to_s
                k = 'last_login' if k == 'last_login_date'
                puts k
            end
        end
    end

    # parse the api result stats into the Player_stats struct
    def parse_player_stats(api_result: nil)

        if !api_result.present?
            api_result = {}
        end

        api_result.deep_symbolize_keys!

        api_result_profile = api_result.dig(:profile) || {}

        Player_stats.new(self.id,
                         api_result_profile.dig(:last_login),
                         api_result_profile.dig(:solo_competitive_rank),
                         get_player_win_lose,
                         api_result_profile.dig(:personaname),
                         api_result_profile.dig(:avatar),
                         api_result_profile.dig(:profileurl),
                         api_result_profile.dig(:loccountrycode))
    end
    # get player win lose rate from dota api
    def get_player_win_lose
        player_winlose = JSON.parse open("https://api.opendota.com/api/players/#{self.user.uid}/wl").read

        if player_winlose["win"] == 0 && player_winlose["lose"] == 0
            0
        else
            100 * player_winlose["win"]/(player_winlose["win"] + player_winlose["lose"])
        end
    end

    def self.min_mmr
        0
    end

    def self.max_mmr
        100000
    end
end
