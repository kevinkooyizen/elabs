# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'open-uri'

# this is to retain yizen, and kent user, player and team
Player.all.destroy_all
Team.all.destroy_all
User.all.destroy_all

players_collection = JSON.parse open("https://api.opendota.com/api/proPlayers").read
seed_counter = 1
max_counter = 20
players_collection.each do |player|
    # seed only 20 players
    break if seed_counter > max_counter

    User.transaction do
        user = User.new
        user.real_name=Faker::Name.name + ((1..1000).to_a).sample.to_s
        user.persona_name=player['personaname']
        user.uid = player["account_id"].to_s
        user.country = player["loccountrycode"]
        user.email = Faker::Internet.email.gsub '@', rand(5000).to_s + '@'
        user.password = 'password'
        user.save!

        if !player['team_id'].present?
            player['team_id']=rand(50000)
        end

        team = Team.find_by_dota2_team_id(player['team_id'].to_i)
        if !team.present?
            team = Team.new
            team.name=Faker::Team.name
            team.dota2_team_id = player['team_id']
            team.save!
        end


        new_player = Player.new
        new_player.user_id = user.id
        new_player.team_id=team.id

        new_player.save!

    end
    seed_counter+=1
end

# The upcoming event is on the bottom because we will treat it as a pass event and will only show the 4 latest event
tour = Dota.api
league_id = 5364
tournaments_collection = tournament_collection.get("IDOTA2Match_570", "GetLeagueListing", league_id: league_id )

tournaments_collection["result"]["leagues"].each do |tournament|
    tournament.name = tournament["name"].gsub(/#DOTA_Item_(\w)/, '\1').split(/_/).join(" ")
    tournament.description = tournament["description"]
    tournament.tournament_url = tournament["tournament_url"]
    # i am not sure what is itemdef is... but Daniel assume it is an id inside the api database 
    tournament.itemdef = tournament["itemdef"]
    tournament.start = Date.new(2016, rand(1..12), rand(1..28))
    tournament.end = tournament.start + 7.days
    tournament.status = true
    tournament.save
end
    
tournament1 = Tournament.new(name: "ROG MASTERS 2017: APAC Qualifier - Singapore", description: "ROG MASTERS 2017 APAC Qualifier Singapore", tournament_url: "http://www.gosugamers.net/dota2/tournaments/16056-wellplay-invitational-9/4773-main-event/16058-main-event/bracket", itemdef: rand(2000), start: "20170829",
end: "20170911")

tournament2 = Tournament.new(name: "King’s Cup: America", description: "6 September, 201", tournament_url: "http://www.gosugamers.net/dota2/tournaments/16290-king-s-cup-america/4848-playoffs/16292-playoffs/bracket", itemdef: rand(2000), start: "20170906",
end: "20170920")

tournament3 = Tournament.new(name: "Prodota Cup #10 SEA", description: "6 September, 201", tournament_url: "http://www.gosugamers.net/dota2/tournaments/16241-prodota-cup-10-sea/4833-playoffs/16244-playoffs/bracket", itemdef: rand(2000), start: "20170908",
end: "20171016")
tournament1.save
tournament2.save
tournament3.save