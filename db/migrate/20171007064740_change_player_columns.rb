class ChangePlayerColumns < ActiveRecord::Migration[5.1]
  def up
    change_column :players, :winrate, :integer, default: 0
    change_column :players, :mmr, :integer, default: 0
  end

  def down
    change_column :players, :winrate, :integer, default: nil
    change_column :players, :mmr, :integer, default: nil
  end
    
end
