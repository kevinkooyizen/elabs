class Team < ApplicationRecord

    has_many :players
    belongs_to :user

    def self.team_search(name: nil, country: nil)
        team_name(name).country(country)
    end

    def self.team_name(name)
        if name.present?
            where('name ilike ?', "%#{name}%")
        else
            all
        end
    end

    def self.country(country)
        if country.present?
            where('country ilike ?', "%#{country}%")
        else
            all
        end
    end
end
