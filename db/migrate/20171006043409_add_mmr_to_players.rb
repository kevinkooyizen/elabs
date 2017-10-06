class AddMmrToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :mmr, :integer
  end
end
