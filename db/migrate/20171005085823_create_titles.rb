class CreateTitles < ActiveRecord::Migration[5.1]
  def change
    create_table :titles do |t|
        t.references :team
        t.references :game
      t.timestamps
    end
  end
end
