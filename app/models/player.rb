class Player < ApplicationRecord
    belongs_to :user
    belongs_to :team
    attr_reader :stats
    before_save :get_player_stats
    validates :user_id, presence: true, uniqueness: true
    validate :validate_is_player

    attr_accessor :is_player

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

    def self.player_search(persona_name: nil,
            real_name: nil, state: nil,
            mmr_lower_range: self.min_mmr,
            mmr_upper_range: self.max_mmr)
        players = self.persona_name(persona_name).real_name(real_name).state(state).includes(:user)
    end
    
    # private

    def validate_is_player
        if !@is_player
            self.errors.add(:id, 'This user does not have a dota profile.')
        end
    end

    def get_player_stats
        api_result = JSON.parse open("https://api.opendota.com/api/players/#{self.user.uid}").read
        api_result.deep_symbolize_keys!

        # todo cater for 2 exception: 1) error 2) user doest not play dota
        if !api_result[:error].present? || api_result[:profile].nil?
            @is_player = false
            return false
        end

        api_result_profile = api_result[:profile]
        # validate the date if its empty
        self.team_id = get_team_id
        self.last_login = Date.strptime(api_result_profile.dig(:last_login), '%Y-%m-%dT%H:%M:%S')
        self.mmr = api_result.dig(:solo_competitive_rank)
        self.winrate = get_player_win_lose
        self.persona_name = api_result_profile.dig(:personaname)
        self.avatar = api_result_profile.dig(:avatar)
        self.profile_url = api_result_profile.dig(:profileurl)

        @is_player = true
        return true
    end

    def get_team_id
        team = Team.where('roster = {?}', self.user.uid)
        if team.present?
            team[0].id
        else
            nil
        end
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
