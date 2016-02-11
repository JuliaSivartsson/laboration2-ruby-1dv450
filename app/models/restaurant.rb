class Restaurant < ActiveRecord::Base
    validates :name, presence: true, length: { in: 3..100 }
end
