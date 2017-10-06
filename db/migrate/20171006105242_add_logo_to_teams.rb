class AddLogoToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :logo, :string
  end
end
