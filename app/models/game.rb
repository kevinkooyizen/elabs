class Game < ApplicationRecord
    has_many :teams, through :titles
end
