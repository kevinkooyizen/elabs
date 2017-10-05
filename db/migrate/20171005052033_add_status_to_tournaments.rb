class AddStatusToTournaments < ActiveRecord::Migration[5.1]
  def change
  	add_column :tournaments, :status, :boolean, default: true
  end
end
