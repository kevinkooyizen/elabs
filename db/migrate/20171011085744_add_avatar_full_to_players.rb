class AddAvatarFullToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :avatar_full, :string
  end
end
