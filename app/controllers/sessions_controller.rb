class SessionsController < ApplicationController
        
    before_filter :authenticate_user, :only => [:home, :profile, :setting]
    before_filter :save_login_state, :only => [:login, :login_attempt]
    protect_from_forgery :except => [:api_auth]

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
          
          #Set JWT Token as message after login - not the way it should be done but I don't know how to test it otherwise
          flash[:JWTToken] = authentication_payload(user)
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
    
    def logout
        session[:user_id] = nil
        flash[:notice] = "Goodbye, hope to see you again!"
        flash[:color] = "valid"
        redirect_to :action => 'login'
    end
    
    def create
        raise request.env["omniauth.auth"].to_yaml
    end
    
    def api_auth 
      # output the APIkey from the header
      # puts request.headers["X-APIkey"]; 
      user = User.find_by(name: params[:name].downcase)
      if user && user.authenticate(params[:password])
        render json: { auth_token: encodeJWT(user) }
      else
        render json: { error: 'Invalid username or password' }, status: :unauthorized
      end
    end
    
end
