class AddInfoToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :winrate, :integer
    add_column :teams, :roster, :text, array: true, default: []
  end
end
