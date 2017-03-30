class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: { minimum: 4, maximum: 32 }
  validates :email, presence: true, uniqueness: true, format: { with: /@/ }
end
