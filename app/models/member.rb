class Member < ApplicationRecord
  belongs_to :team
  validates :account_id, uniqueness: true
end
