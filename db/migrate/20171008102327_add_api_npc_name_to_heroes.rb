class AddApiNpcNameToHeroes < ActiveRecord::Migration[5.1]
  def change
    add_column :heroes, :api_npc_name, :string
  end
end
