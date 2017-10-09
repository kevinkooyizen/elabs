class CreateEnquiries < ActiveRecord::Migration[5.1]
  def change
    create_table :enquiries do |t|
      t.references :user, foreign_key: true
      t.references :team, foreign_key: true
      t.integer :user_uid

      t.timestamps
    end
  end
end
