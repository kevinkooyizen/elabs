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

    # combined search scope
    def self.team_search(name: nil, country: nil)
        team_name(name).country(country)
    end

    # search scope
    def self.team_name(name)
        if name.present?
            where('name ilike ?', "%#{name}%")
        else
            all
        end
    end

    # search scope
    def self.country(country)
        if country.present?
            where('country ilike ?', "%#{country}%")
        else
            all
        end
    end

    # get the players of this team
    def get_roster_players
        players_id = self.roster.map {|id| id.to_i}
        Player.where('steam_id in (?)', players_id).extend(DescriptiveStatistics)
    end

    # get the all players for all the teams
    def self.get_roster_players
        players_id = self.pluck(:roster).reduce([]) {|result, roster|
            result+=roster
        }
        players_id.map! {|id| id.to_i}
        Player.where('steam_id in (?)', players_id)
    end

    # compute team mmr mean from the roster players
    def team_mmr_mean(nil_as_zero = true)
        mean = get_roster_players.mean(&:mmr)

        if nil_as_zero == true
            if !mean.present?
                return 0
            end
        end

        mean
    end

    # compute team mmr median from the roster players
    def team_mmr_median(nil_as_zero = true)
        median = get_roster_players.median(&:mmr)

        if nil_as_zero == true
            if !mean.present?
                return 0
            end
        end

        median
    end

    # get the attribute vector for similarity calculation
    def get_team_vector
        [self.team_mmr_mean, self.winrate]
    end

    # compute the similarity of a team with all the players
    def get_all_cosine_distance
        players_vectors = Player.all.pluck(:id, :mmr, :winrate)

        # return empty array if there is no player
        # quite unlikely, but might happen during early DB setup
        if !players_vectors.present?
            return []
        end

        # replace nil with 0 in the vector
        players_vectors.map!{|vector|
            vector.map!{|ele|
                if !ele.present?
                    0
                else
                    ele
                end
            }
        }

        v_team = self.get_team_vector

        # replace nil with 0 in the vector
        v_team.map! {|ele|
            if !ele.present?
                0
            else
                ele
            end
        }

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

    # get the all the players sorted by cosine similarity scoring
    def players_sorted_by_similarity
        players_scoring = get_all_cosine_distance

        if !players_scoring.present?
            return []
        end

        players = Player.where('id in (?)', players_scoring.map {|v| v[0]})
        players_scoring = players_scoring.to_h

        # return an array of sorted players
        players.sort {|first, second|
            players_scoring[second.id] <=> players_scoring[first.id]
        }
    end
end
