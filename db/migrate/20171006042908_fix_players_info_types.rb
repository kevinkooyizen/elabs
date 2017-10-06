class FixPlayersInfoTypes < ActiveRecord::Migration[5.1]
  def up
    change_column :players, :real_name, :string
    change_column :players, :persona_name, :string
    change_column :players, :team_name, :string
    change_column :players, :avatar, :string
    change_column :players, :profile_url, :string
    change_column :players, :last_login, :string
    change_column :players, :country_code, :string
  end

  def down
    change_column :players, :real_name, :integer
    change_column :players, :persona_name, :integer
    change_column :players, :team_name, :integer
    change_column :players, :avatar, :integer
    change_column :players, :profile_url, :integer
    change_column :players, :last_login, :integer
    change_column :players, :country_code, :integer
  end
end
