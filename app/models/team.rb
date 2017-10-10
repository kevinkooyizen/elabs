require 'descriptive_statistics'
class Team < ApplicationRecord
    include RankingExtension::CosineDistance

    paginates_per 8
    belongs_to :user
    has_many :sponsorships
    has_many :sponsors, through: :sponsorships
    has_many :tournaments, through: :participants

    has_many :games, through: :titles
    has_many :titles

    has_many :enquiries

    has_many :members
    # combined search scope
    def self.team_search(name: nil, country: nil, min_rating: nil, max_rating: nil)
        team_name(name).country(country).min_rating(min_rating.to_i).max_rating(max_rating.to_i)
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

    def self.min_rating(rating)
        if rating.present?
            where('rating > ?', rating)
        else
            all
        end
    end

    def self.max_rating(rating)
        if rating.present?
            where('rating < ?', rating)
        else
            all
        end
    end

    # manual association to players, 1 team has many players
    def players
        Player.where('team_id = ?', self.id)
    end

    # get the players of this team
    def get_team_players
        Player.where('steam_id in (?)', self.members.pluck(:account_id)).extend(DescriptiveStatistics)
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
        mean = self.get_team_players.mean(&:mmr)

        if nil_as_zero == true
            if !mean.present?
                return 0
            end
        end

        mean
    end

    # compute team mmr median from the roster players
    def team_mmr_median(nil_as_zero = true)
        median = self.get_team_players.median(&:mmr)

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

    def get_enquiries_users(team_id = self.id)
        users_ids = Enquiry.where('team_id = ?', team_id).pluck(:user_id)

        enquired_users = User.where('users.id in (?)', users_ids).includes(:player)
    end

    #  def self.filter(filtering_params)
    #   results = self.where(nil)
    #      if filtering_params.to_i <= 1000
    #         filtering_params= nil
    #     else
    #         results = filtering_params if filtering_params.present?
    #     end
        
    #   results
    # end
end
