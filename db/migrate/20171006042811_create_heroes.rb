class CreateHeroes < ActiveRecord::Migration[5.1]
  def change
    create_table :heroes do |t|
    	t.integer :api_id
    	t.string :api_name
    	t.string :name
    	t.decimal :win_rate, :precision => 5, :scale => 2
    	t.decimal :picked, :precision => 5, :scale => 2

    	t.timestamps
    end
  end
end
