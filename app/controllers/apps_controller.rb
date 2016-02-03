class AppsController < ApplicationController
    before_filter :authenticate_user, :only => [:new, :create]
      
    def new
        #Application form
        @application = App.new
    end
    
    def create
        #Create a new application
        apiKey = generate_api_key
        
        @application = App.new(apps_params)
        if @application.save
            @application.update_attribute(:apikey, apiKey)
          flash[:notice] = "Yay, your registration was successful"
          flash[:color] = "valid"
        else
          flash[:notice] = "Darn, something went wrong!"
          flash[:color] = "invalid"
        end
        redirect_to "/profile"
    end
    
    def apps_params
        params.require(:application).permit(:name, :description, :user_id, :apikey)
    end
    
    #Found help on how to generate apiKey here: http://blog.joshsoftware.com/2014/05/08/implementing-rails-apis-like-a-professional/
    def generate_api_key
      loop do
        token = SecureRandom.base64.tr('+/=', 'Qrt')
        break token
      end
    end
end
