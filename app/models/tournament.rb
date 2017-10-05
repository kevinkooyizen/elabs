class Tournament < ApplicationRecord

	def self.display_tournaments
		Tournament.all.order(start: :desc).limit(8)
	end
end
