class Player < ApplicationRecord
    belongs_to :user
    belongs_to :team

    def self.real_name

    end

end
