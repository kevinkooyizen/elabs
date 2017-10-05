class Tournament < ApplicationRecord
    has_many :teams, through :participants

	def show_tournament
		url = URI("https://api.sportradar.us/dota2-t1/us/tournaments/sr:tournament:2464/results.xml?api_key=#{ENV['RADAR_KEY']}")

		http = Net::HTTP.new(localhost, 3000)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		request = Net::HTTP::Get.new(url)

		response = http.request(request)
		puts response.read_body
	end	

end
