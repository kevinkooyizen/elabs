class Team < ApplicationRecord
    include RankingExtension::CosineDistance

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

    def get_roster_players
        players_id = self.roster.map {|id| id.to_i}
        Player.where('steam_id in (?)', players_id).extend(DescriptiveStatistics)
    end

    def self.get_roster_players
        players_id = self.pluck(:roster).reduce([]) {|result, roster|
            result+=roster
        }
        players_id.map! {|id| id.to_i}
    end

    def team_mmr_mean(nil_as_zero = true)
        mean = get_roster_players.mean(&:mmr)

        if nil_as_zero == true
            if !mean.present?
                return 0
            end
        end

        mean
    end

    def team_mmr_median(nil_as_zero = true)
        median = get_roster_players.median(&:mmr)

        if nil_as_zero == true
            if !mean.present?
                return 0
            end
        end

        median
    end

    def get_team_vector
        [self.team_mmr_mean, self.winrate]
    end

    def get_all_cosine_distance
        players_vectors = Player.all.pluck(:id, :mmr, :winrate)

        if !players_vectors.present?
            return []
        end

        v_team = self.get_team_vector

        # return an array with players subarray [id, cosine_distrance]
        cosine_distance = players_vectors.map {|vector|
            v_player = [vector[1], vector[2]]
            [vector[0], cosine_distance(v_team, v_player)]
        }

        cosine_distance.sort! {|first, second|
            second[1] <=> first[1]
        }

        return cosine_distance
    end

    def id_sorted_by_cosine_distance
        similarities = get_all_cosine_distance

        if !similarities.present?
            return []
        end

        # return a hash with key as player id and object as player active record
        players = Player.where('id in (?)', similarities.map {|v| v[0]})
        similarities = similarities.to_h
        players.sort {|first, second|
            similarities[second.id] <=> similarities[first.id]
        }
    end
end
