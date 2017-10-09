class Player < ApplicationRecord
    include RankingExtension::CosineDistance
    include ApiExtension

    belongs_to :user
    belongs_to :team
    attr_reader :stats
    before_validation :get_player_stats
    validates :user_id, presence: true, uniqueness: true
    validate :validate_is_player

    attr_accessor :is_player, :uid

    def self.persona_name(persona_name=nil)
        if persona_name.present?
            self.joins(:user).where('users.persona_name ilike ?', "%#{persona_name}%")
        else
            self.all
        end
    end

    def self.real_name(real_name=nil)
        if persona_name.present?
            self.joins(:user).where('users.real_name ilike ?', "%#{real_name}%")
        else
            self.all
        end
    end

    def self.state(state=nil)
        if state.present?
            self.where("state ilike ?", "%#{state}%")
        else
            self.all
        end
    end

    def self.mmr(mmr_lower_range, mmr_upper_range)
        if !mmr_lower_range.present?
            mmr_lower_range = self.min_mmr
        end

        if !mmr_upper_range.present?
            mmr_upper_range = self.max_mmr
        end

        self.where('mmr >= ? and mmr <= ?', mmr_lower_range.to_i, mmr_upper_range.to_i)
    end

    def self.player_search(persona_name: nil,
            real_name: nil, state: nil,
            mmr_lower_range: self.min_mmr,
            mmr_upper_range: self.max_mmr)

        players = self.persona_name(persona_name).real_name(real_name).state(state).mmr(mmr_lower_range, mmr_upper_range).includes(:user)
    end

    # should return the active relation object of Hero
    def get_heroes
        heroes = self.top_heroes
        heroes.map! {|id| id.to_i}

        Hero.where('id in (?)', heroes)
    end

    def get_player_stats(player_uid = self.user.uid)
        # api_result = JSON.parse open("https://api.opendota.com/api/players/#{player_uid}").read
        api_result = OpenDota.get_player_profile(uid: player_uid)
        api_result.deep_symbolize_keys!

        # cater for 2 exception:
        # 1) error
        # 2) user doest not play dota
        if api_result[:error].present? || api_result[:profile].nil?
            @is_player = false
            return false
        end

        api_result_profile = api_result[:profile]
        # validate the date if its empty
        self.team_id = self.get_team_id(player_uid)
        last_login = api_result_profile.dig(:last_login)
        self.last_login = last_login.nil? ? nil : Date.strptime(last_login, '%Y-%m-%dT%H:%M:%S')
        self.mmr = api_result.dig(:solo_competitive_rank)||0
        self.winrate = get_player_win_lose(player_uid)||0
        self.top_heroes = get_top_3_heroes(player_uid)
        self.persona_name = api_result_profile.dig(:personaname)
        self.avatar = api_result_profile.dig(:avatar)
        self.profile_url = api_result_profile.dig(:profileurl)
        self.steam_id = player_uid.to_i

        @is_player = true
        return true
    end

    def get_team_id(player_uid)
        team = Team.where("roster @> ?", "{#{player_uid}}")
        if team.present?
            team[0].id
        else
            nil
        end
    end

    def get_top_3_heroes(player_uid)
        # the api will return an array of all the heroes and the corresponding stats
        # heroes = JSON.parse open("https://api.opendota.com/api/players/#{player_uid}/heroes").read
        heroes = OpenDota.get_player_heroes(uid: player_uid)

        # api will return a hash if there is any error
        if heroes.is_a? Hash
            if heroes['error'].present?
                return nil
            end
        end

        heroes[0...default_heroes_count].sort_by! do |hero|
            if hero["games"].to_i == 0 || hero["win"].to_i == 0
                0
            else
                1/(hero["win"].to_f/hero["games"].to_i)
            end
        end

        heroes[0..2].map {|hero| hero["hero_id"].to_i}
    end

    def default_heroes_count
        10
    end

    # get player win lose rate from dota api
    def get_player_win_lose(player_uid)
        # player_winlose = JSON.parse open("https://api.opendota.com/api/players/#{player_uid}/wl").read
        player_winlose = OpenDota.get_player_winlose(uid: player_uid)

        if player_winlose["win"] == 0 && player_winlose["lose"] == 0
            0
        else
            100 * player_winlose["win"]/(player_winlose["win"] + player_winlose["lose"])
        end
    end


    def get_player_vector
        [self.mmr, self.winrate]
    end

    def get_all_cosine_distance
        teams_vector = Team.all.map { |team|
            [team.id, team.team_mmr_mean, team.winrate]
        }


        if !teams_vector.present?
            return []
        end

        teams_vector.map! {|team|
            team.map! {|ele|
                if !ele.present?
                    0
                else
                    ele
                end
            }
        }

        v_player = self.get_player_vector

        v_player.map! {|ele|
            if !ele.present?
                0
            else
                ele
            end
        }

        cosine_distance = teams_vector.map {|vector|
            team_id = vector[0]
            v_team = [vector[1], vector[2]]
            [team_id, cosine_distance(v_team, v_player)]
        }

        cosine_distance.sort! {|first, second|
            second[1]<=>first[1]
        }

        return cosine_distance

    end

    def teams_sorted_by_similarity
        teams_scoring = get_all_cosine_distance

        if !teams_scoring.present?
            return []
        end

        teams = Team.where('id in (?)', teams_scoring.map {|v| v[0]})
        teams_scoring = teams_scoring.to_h

        # return an array of sorted players
        teams.sort {|first, second|
            teams_scoring[second.id] <=> teams_scoring[first.id]
        }
    end

    private

    def validate_is_player
        if !@is_player
            self.errors.add(:id, 'This user does not have a dota profile.')
        end
    end

    def self.min_mmr
        0
    end

    def self.max_mmr
        100000
    end
end
