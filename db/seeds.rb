# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'open-uri'
require 'csv'

# this is to retain yizen, and kent user, player and team
Player.all.destroy_all
Team.destroy_all
# User.all.destroy_all
# Happening.all.destroy_all

# players_collection = JSON.parse open("https://api.opendota.com/api/proPlayers").read
# seed_counter = 1
# max_counter = 20
# players_collection.each do |player|
#     # seed only 20 players
#     break if seed_counter > max_counter

#     User.transaction do
#         user = User.new
#         user.real_name=Faker::Name.name + ((1..1000).to_a).sample.to_s
#         user.persona_name=player['personaname']
#         user.uid = player["account_id"].to_s
#         user.country = player["loccountrycode"]
#         user.email = Faker::Internet.email.gsub '@', rand(5000).to_s + '@'
#         user.password = 'password'
#         user.save!

#         if !player['team_id'].present?
#             player['team_id']=rand(50000)
#         end

#         team = Team.find_by_dota2_team_id(player['team_id'].to_i)
#         if !team.present?
#             team = Team.new
#             team.name=Faker::Team.name
#             team.dota2_team_id = player['team_id']
#             team.user_id = user.id
#             team.save!
#         end


#         new_player = Player.new
#         new_player.user_id = user.id
#         new_player.team_id=team.id

#         new_player.save!

#     end
#     seed_counter+=1
# end

# # The upcoming event is on the bottom because we will treat it as a pass event and will only show the 4 latest event
# tour = Dota.api
# league_id = 5364
# tournaments_collection = tour.get("IDOTA2Match_570", "GetLeagueListing", league_id: league_id )
# Tournament.transaction do
#     tournaments_collection["result"]["leagues"].each do |item|
#         tournament= Tournament.new

# tournaments_collection["result"]["leagues"].each do |item|
#     tournament= Tournament.new
#     tournament.transaction do
#         tournament.name = item["name"].gsub(/#DOTA_Item_(\w)/, '\1').split(/_/).join(" ")
#         tournament.description = item["description"]
#         tournament.tournament_url = item["tournament_url"]
#         # i am not sure what is itemdef is... but Daniel assume it is an id inside the api database
#         tournament.itemdef = item["itemdef"]
#         tournament.start = Date.new(2016, rand(1..12), rand(1..28))
#         tournament.end_date = tournament.start + 7.days
#         tournament.game = "dota2"
#         tournament.status = true
#         tournament.save
#     end
# end

# tournament1 = Tournament.new(name: "ROG MASTERS 2017: APAC Qualifier - Singapore", description: "ROG MASTERS 2017 APAC Qualifier Singapore", tournament_url: "http://www.gosugamers.net/dota2/tournaments/16056-wellplay-invitational-9/4773-main-event/16058-main-event/bracket", itemdef: rand(1800..2000), start: "20170829",
# end_date: "20170911", game: "dota2")

# tournament2 = Tournament.new(name: "King’s Cup: America", description: "King's Cup: America", tournament_url: "http://www.gosugamers.net/dota2/tournaments/16290-king-s-cup-america/4848-playoffs/16292-playoffs/bracket", itemdef: rand(1800..2000), start: "20170906",
# end_date: "20170920", game: "dota2")

# tournament3 = Tournament.new(name: "Prodota Cup #10 SEA", description: "Prodota Cup #10 SEA", tournament_url: "http://www.gosugamers.net/dota2/tournaments/16241-prodota-cup-10-sea/4833-playoffs/16244-playoffs/bracket", itemdef: rand(1800..2000), start: "20170908",
# end_date: "20171016", game: "dota2")
# tournament1.save
# tournament2.save
# tournament3.save

# Happening.all.destroy_all
# # seed events data, no dependency
# max_counter = 20
# location = ['KL', 'PNG', 'JB']
# date_range = (Date.new(2017,6,1)..Date.new(2017,10,30)).to_a
# max_counter.times do
#     happening = Happening.new
#     happening.name = Faker::Lorem.sentence
#     happening.location = location.sample
#     happening.detail = Faker::Lorem.paragraph
#     happening.time = date_range.sample
#     happening.save
# end

heroes_collection = JSON.parse open("https://api.opendota.com/api/heroes").read
Hero.transaction do
    heroes_collection.each do |item|
        counter =0
        hero = Hero.new
        hero.api_id = item["id"]
        hero.api_name = item["localized_name"]
        hero_file =File.join(File.dirname(__FILE__), 'hero_stats.csv')
        CSV.foreach(hero_file) do |row|
            counter+=1
            if hero.api_name == row[0]
                next if counter == 1
                hero.name = row[0]
                hero.win_rate = row[1]
                hero.picked = row[2]
            end
        end
        hero.save
    end
end
@teams = JSON.parse open("https://api.opendota.com/api/teams").read
@pros = JSON.parse open("https://api.opendota.com/api/proPlayers").read
@user = User.new
@user.real_name = "fake dummy"
@user.email = Faker::Internet.email.gsub '@', rand(5000).to_s + '@'
@user.password = 'password'
@user.save!

@teams.each do |select|

    Team.transaction do
        team = Team.new
        team.name = select["name"]
        team.dota2_team_id = select["team_id"]
        if !select["rating"].nil?
            team.rating = select["rating"]
        else
            team.rating = 0
        end
        team.status = true
        team.user_id = @user.id
        team.winrate = (100 * select["wins"].to_f/(select["wins"].to_f + select["losses"].to_f)).round(2)
        @pros.select do |item|
            if item["team_name"] == select["name"] && item["locked_until"] != 0 && item["is_locked"] && item["is_pro"]
                # this stores 32 bit player steam profile id into roster
                team.roster << item["account_id"]
            end
        end
        team.save
    end
end