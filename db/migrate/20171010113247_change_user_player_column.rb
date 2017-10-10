class ChangeUserPlayerColumn < ActiveRecord::Migration[5.1]
  def up
    rename_column :users, :player, :player_status
    remove_column :users, :mmr
    add_column :users, :mmr, :integer, default: 0
  end

  def down
    rename_column :users, :player_status, :player
    remove_column :users, :mmr
    add_column :users, :mmr, :string
  end
end
