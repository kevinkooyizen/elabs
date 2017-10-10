class RemoveMmrFromUsers < ActiveRecord::Migration[5.1]
  def up
    remove_column :users, :mmr
    remove_column :users, :player_status
  end

  def down
    add_column :users, :mmr, :integer
    add_column :users, :player_status, :boolean
  end
end
