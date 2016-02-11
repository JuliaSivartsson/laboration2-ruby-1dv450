class AppsController < ApplicationController
    before_filter :authenticate_user, :only => [:new, :create]
      
    def new
        #Application form
        @application = App.new
    end
    
    def create
        #Create a new application
        @application = App.new(apps_params)
        
        # Make sure apikey's are unique and random: http://ruby-doc.org/stdlib-1.9.2/libdoc/securerandom/rdoc/SecureRandom.html
        
        if @application.save
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
    
    def delete_application
        #Delete application
        @app_to_delete = App.find(params[:id])
        if @app_to_delete.present?
            @app_to_delete.destroy
            flash[:notice] = "Application is now deleted!"
            flash[:color] = "valid"
        else
          flash[:notice] = "Something went wrong, could not delete the application"
          flash[:color] = "invalid"
        end
        redirect_to "/profile"
    end
    
end
