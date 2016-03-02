class Position < ActiveRecord::Base
    geocoded_by :address
    validates :address, presence: true, uniqueness: true

    #If the address is different then run geocode
    after_validation :geocode, :if => :address_changed?
    has_many :restaurants
end
