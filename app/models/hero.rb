class Hero < ApplicationRecord
  self.table_name = 'heroes'

  def self.display_heroes
  	Hero.all.order(win_rate: "desc").limit(10)
  end

end
