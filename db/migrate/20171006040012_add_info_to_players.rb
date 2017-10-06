class AddInfoToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :real_name, :integer
    add_column :players, :persona_name, :integer
    add_column :players, :team_name, :integer
    add_column :players, :winrate, :integer
    add_column :players, :top_heroes, :text, array: true, default: []
    add_column :players, :steam_id, :integer
    add_column :players, :avatar, :integer
    add_column :players, :profile_url, :integer
    add_column :players, :last_login, :integer
    add_column :players, :country_code, :integer
  end
end
