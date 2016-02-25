class Creator < ActiveRecord::Base
    has_many :restaurants
    
    has_secure_password
    
    EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :name, presence: true, length: { within: 3..20 }
    validates :email, presence: true, format: {with: EMAIL_REGEX}, uniqueness: {case_sensitive: false}
    validates :password, presence: true, length: {within: 6..40}
  validates :password_confirmation, presence: true
end
