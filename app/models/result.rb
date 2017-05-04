class Result < ApplicationRecord
  belongs_to :match
  belongs_to :captain, class_name: 'User', foreign_key: 'user_id'

  validates :match, uniqueness: { scope: :user_id, message: 'You have added result already' }
  validates :home_score, presence: true
  validates :away_score, presence: true
end
