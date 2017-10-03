class CreateTournaments < ActiveRecord::Migration[5.1]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.datetime :start
      t.datetime :end
      t.string :game

      t.timestamps
    end
  end
end
