class Tournament < ApplicationRecord
    has_many :teams, through: :participants

    def self.tournament_name(tournament_name)
    	if tournament_name.present?
 	   		where("name LIKE ?", "%#{tournament_name}%")
    	else
    		all
    	end
    end

    def self.description(description)
    	if description.present?
    		where(["description LIKE ?", "%#{description}%"])
    	else
    		all
    	end
    end

    def self.start(start)
    	if start.present?
    		where(["start >=?", start])
    	else	
    		all
    	end
    end

    def self.tournament_end(tournament_end)
    	if tournament_end.present?
    		where(["end_date >=?", tournament_end])
    	else
    		all
    	end
    end

    def self.game(game)
    	if game.present?
    		where(["game LIKE?", "%#{game}%"])
    	else
    	end
    end

    def self.tournament_search(name: nil, description: nil, start: nil, end_date: nil, game: nil)
    	tournament_name(name).description(description).start(start).tournament_end(end_date).game(game)
	end

	def self.display_tournaments
		Tournament.all.order(start: :desc).limit(8)
	end
end
