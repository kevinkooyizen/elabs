class Tournament < ApplicationRecord

	def self.display_tournaments
		tour = Dota.api
		league_id = 5364
		tournaments = tour.get("IDOTA2Match_570", "GetLeagueListing", league_id: league_id )
	end

	def self.display_matches_history
		match_history_id = 3483429548
		matches = JSON.parse open("https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/?key=#{ENV["STEAM_KEY"]}").read
	end
end
