class CreateSponsorships < ActiveRecord::Migration[5.1]
  def change
    create_table :sponsorships do |t|
      t.references :sponsor, foreign_key: true
      t.references :team, foreign_key: true
      t.references :game, foreign_key: true

      t.timestamps
    end
  end
end
