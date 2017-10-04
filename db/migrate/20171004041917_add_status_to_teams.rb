class AddStatusToTeams < ActiveRecord::Migration[5.1]
  def change
  	add_column :teams, :status, :boolean, default: true
  end
end
