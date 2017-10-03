class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :sponsor
      t.string :coach
      t.string :manager
      t.string :country

      t.timestamps
    end
  end
end
