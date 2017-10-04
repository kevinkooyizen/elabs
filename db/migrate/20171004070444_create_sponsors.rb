class CreateSponsors < ActiveRecord::Migration[5.1]
  def change
    create_table :sponsors do |t|
      t.string :company_name
      t.string :company_email
      t.integer :company_phone

      t.timestamps
    end
  end
end
