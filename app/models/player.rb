class Player < ApplicationRecord
    belongs_to :user
    belongs_to :team

    scope :persona_name, -> (persona_name) {User.where('persona_name ilike ?', "%#{persona_name}%") if persona_name.present?}
    scope :state, -> (state) {User.where("state ilike ?", "%#{state}%") if state.present?}

    def self.player_search(persona_name: nil, state: nil, mmr:nil)
        users = self.persona_name(persona_name).state(state)

        user_stats_struct = Struct.new(user_id, mmr)

        if users.present?
            users.each do |user|
            #     fire the dota api

            end
        end
    end


end
