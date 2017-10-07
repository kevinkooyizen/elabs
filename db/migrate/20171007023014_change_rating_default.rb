class ChangeRatingDefault < ActiveRecord::Migration[5.1]
  def up
    change_column :teams, :rating, :integer, default: 0
  end

  def down
    change_column :teams, :rating, :integer, default: nil
  end
    
end
