class ChangedTeamWinrateToFloat < ActiveRecord::Migration[5.1]
  def up
    change_column :teams, :winrate, :float
  end

  def down
    change_column :teams, :winrate, :integer
  end
end
