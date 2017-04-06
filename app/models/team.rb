class Team < ApplicationRecord
  belongs_to :captain, class_name: 'User', foreign_key: 'user_id'

  validates :name, presence: true, length: { in: 3..32 }, uniqueness: { case_sensitive: false }
end