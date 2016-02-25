class Restaurant < ActiveRecord::Base
    validates :name, presence: true, length: { in: 3..100 }
    
    belongs_to :position
    belongs_to :creator
    has_and_belongs_to_many :tags
    
end
