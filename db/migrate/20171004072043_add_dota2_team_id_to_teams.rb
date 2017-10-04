class AddDota2TeamIdToTeams < ActiveRecord::Migration[5.1]
  def change
  	add_column :teams, :dota2_team_id, :integer
  end
end
