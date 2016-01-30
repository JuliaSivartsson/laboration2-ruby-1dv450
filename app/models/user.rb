class User < ActiveRecord::Base
      
    #Hash password in database
    has_secure_password
    validates :name, presence: true, uniqueness: true, length: { in: 3..20 }
    validates_length_of :password, in: 6..30, on: :create
    
    has_many :app
end
