class AppsController < ApplicationController
    before_filter :authenticate_user, :only => [:new, :create]
      
    def new
        #Application form
        @application = App.new
    end
    
    def create
        #Create a new application
        random = rand(2000...5000)
        @application = App.new(apps_params)
        if @application.save
            @application.update_attribute(:apikey, random)
          flash[:notice] = "Yay, your registration was successful"
          flash[:color] = "valid"
        else
          flash[:notice] = "Darn, something went wrong!"
          flash[:color] = "invalid"
        end
        render "new"
    end
    
    def delete_application
        #Delete application WHY DO I GET ERROR?
      @app_to_delete = App.find(params[:id])
      @app_to_delete.destroy
      render "profile"
    end
    
    def apps_params
        params.require(:application).permit(:name, :description, :user_id, :apikey)
    end
end
