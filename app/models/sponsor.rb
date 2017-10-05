class Sponsor < ApplicationRecord
    belongs_to :user
    has_many :teams, through :sponsorships
    has_many :sponsorships
end
