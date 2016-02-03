class SessionsController < ApplicationController
        
    before_filter :authenticate_user, :only => [:home, :profile, :setting]
    before_filter :save_login_state, :only => [:login, :login_attempt]

    def login
        #Login form
    end
    
    def login_attempt
        user = User.find_by_name(params[:name])
        if user && user.authenticate(params[:login_password])
            #Set session for logged in user
          session[:user_id] = user.id
          flash[:notice] = "Yay, you are now logged in!"
          flash[:color] = "valid"
          redirect_to(:action => 'home')
        else
        
          flash.now[:notice] = "You didn't login, something went wrong!"
          flash.now[:color] = "invalid"
          render "login"
        end
    end
    
    def home
        #Home view
    end
    
    def profile
        @applications = App.order('id DESC').all
    end
    
    def delete_application
        #Delete application
        @app_to_delete = App.find_by_id(params[:id])
        if @app_to_delete.destroy
            flash[:notice] = "Application is now deleted!"
            flash[:color] = "valid"
        else
          flash[:notice] = "Something went wrong, could not delete the application"
          flash[:color] = "invalid"
        end
        redirect_to :action => "profile"
    end
    
    def logout
        session[:user_id] = nil
        flash[:notice] = "Goodbye, hope to see you again!"
        flash[:color] = "valid"
        redirect_to :action => 'login'
    end
end
