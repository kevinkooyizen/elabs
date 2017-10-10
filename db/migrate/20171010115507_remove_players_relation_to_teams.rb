class RemovePlayersRelationToTeams < ActiveRecord::Migration[5.1]
  def up
    remove_foreign_key :players, "teams"
  end

  def down
    add_foreign_key "players", "teams"
  end
end
