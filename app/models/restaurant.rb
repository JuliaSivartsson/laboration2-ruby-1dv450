class Restaurant < ActiveRecord::Base
    validates :name, presence: true, length: { in: 3..100 }
    validates :message, presence: true
    validates :rating, presence: true, :inclusion => 0..5
    validates :position, presence: true
    
    belongs_to :position
    belongs_to :creator
    has_and_belongs_to_many :tags
    
end
