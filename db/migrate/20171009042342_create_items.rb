class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.integer :api_id
      t.string :api_name

      t.timestamps
    end
  end
end
