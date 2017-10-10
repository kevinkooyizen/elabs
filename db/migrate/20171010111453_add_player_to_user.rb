class AddPlayerToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :player, :boolean, default: false
    add_column :users, :mmr, :string
  end
end
