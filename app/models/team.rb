class Team < ApplicationRecord
    paginates_per 5
    has_many :players
    belongs_to :user
    has_many :sponsorships
    has_many :sponsors, through: :sponsorships
    has_many :tournaments, through: :participants

    has_many :games, through: :titles
    has_many :titles

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
