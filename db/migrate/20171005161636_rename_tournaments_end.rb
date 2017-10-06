class RenameTournamentsEnd < ActiveRecord::Migration[5.1]
  def up
    rename_column :tournaments, :end, :end_date
  end

  def down
    rename_column :tournaments, :end_date, :end
  end
end
