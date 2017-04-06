class User < ApplicationRecord
  has_many :teams
  has_many :tournaments, foreign_key: :creator_id

  before_save { self.email = email.downcase }

  has_secure_password

  validates :name, presence: true, length: { minimum: 4, maximum: 32 }
  validates :email, presence: true, uniqueness: true, format: { with: /@/ }, length: { maximum: 255 }

  class << self
    def digest(password)
      cost = ActiveModel::SecurePassword.min_cost ?
          BCrypt::Engine::MIN_COST : BCrypt::Engine.cost

      BCrypt::Password.create(password, cost: cost)
    end
  end
end

