# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'open-uri'

players_collection = JSON.parse open("https://api.opendota.com/api/proPlayers").read

players_collection.each do |player|
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

end

