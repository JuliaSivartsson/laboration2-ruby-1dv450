class App < ActiveRecord::Base
    validates :name, presence: true, length: { in: 3..100 }
    validates :description, presence: true, length: { in: 3..250 }
    validates :apikey, presence: true
    
    belongs_to :user
end
