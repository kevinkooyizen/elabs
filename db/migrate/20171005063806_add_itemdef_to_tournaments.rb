class AddItemdefToTournaments < ActiveRecord::Migration[5.1]
  def change
  	add_column :tournaments, :itemdef, :string
  end
end
