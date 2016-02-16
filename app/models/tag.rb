class Tag < ActiveRecord::Base
    
    has_and_belongs_to_many :restaurants
    
    validates :name, presence: true, uniqueness: true, length: { in: 3..50 }
    
end
