class AddDescriptionToTournaments < ActiveRecord::Migration[5.1]
  def change
  	add_column :tournaments, :description, :string
  end
end
