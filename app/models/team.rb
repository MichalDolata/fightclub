class Team < ApplicationRecord
  belongs_to :captain, class_name: 'User', foreign_key: 'user_id'
  has_and_belongs_to_many :tournaments, uniq: true

  validates :name, presence: true, length: { in: 3..32 }, uniqueness: { case_sensitive: false }
end