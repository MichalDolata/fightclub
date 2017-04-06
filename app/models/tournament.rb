class Tournament < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_and_belongs_to_many :teams

  validates :name, presence: true, length: { in: 3..64 }
  validates :teams_count, inclusion: { in: 2..1024 }, power_of_two: true
end