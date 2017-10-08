class AddImageToTournaments < ActiveRecord::Migration[5.1]
  def change
  	add_column :tournaments, :image, :string
  end
end
