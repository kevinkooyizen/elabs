class CreateMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :members do |t|
      t.references :team, foreign_key: true
      t.string :name
      t.integer :account_id

      t.timestamps
    end
  end
end
