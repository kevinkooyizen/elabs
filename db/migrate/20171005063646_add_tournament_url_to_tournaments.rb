class AddTournamentUrlToTournaments < ActiveRecord::Migration[5.1]
  def change
  	add_column :tournaments, :tournament_url, :string 
  end
end
