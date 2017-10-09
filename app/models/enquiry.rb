class Enquiry < ApplicationRecord
    belongs_to :user
    belongs_to :team
    validates :team_id, uniqueness: { scope: :user_uid, message: "cannot apply the same team twice" }

end
