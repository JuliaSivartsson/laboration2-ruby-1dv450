class App < ActiveRecord::Base
    before_create :generate_api_key
    
    validates :name, presence: true, length: { in: 3..100 }
    validates :description, presence: true, length: { in: 3..250 }
    
    belongs_to :user
    
    private
    
    def generate_api_key
        begin
            self.apikey = SecureRandom.hex
        end while self.class.exists?(apikey: apikey)
    end
end
