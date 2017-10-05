class Tournament < ApplicationRecord
    has_many :teams, through :participants

	def self.display_tournaments
		Tournament.all.order(start: :desc).limit(8)
	end
end
