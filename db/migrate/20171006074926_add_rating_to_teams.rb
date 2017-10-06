class AddRatingToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :rating, :integer
  end
end
