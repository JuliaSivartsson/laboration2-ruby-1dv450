class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_cache_buster
  #include Knock::Authenticable
  
  
  #DEFAULT PARAMETERS
  OFFSET = 0
  LIMIT = 20
  
  #Check if user wants to set own offset/limit
  def offset_params
    if params[:offset].present?
      @offset = params[:offset].to_i
    end
    if params[:limit].present?
      @limit = params[:limit].to_i
    end
    @offset ||= OFFSET
    @limit  ||= LIMIT
  end
  
  def authenticate_user
    if session[:user_id]
      @current_user = User.find session[:user_id]
      return true
    else
      redirect_to(:controller => 'sessions', :action => 'login')
      return false
    end
  end
  
  def save_login_state
    if session[:user_id]
      redirect_to(:controller => 'sessions', :action => 'home')
      return false
    else
      return true
    end
  end
  
  def restrict_access
    api_key = App.find_by_apikey(params[:access_token])
    
    #If key does not exist
    unless api_key
      render json: { message: "The API-key was not valid"}, status: :unauthorized
    end
  end
  
  #API authentication with JWT
  def api_authenticate
    if request.headers["Authorization"].present?
      auth_header = request.headers['Authorization'].split(' ').last
      @token_payload = decodeJWT auth_header.strip
      if !@token_payload
        render json: { error: 'The provided token wasn´t correct' }, status: :bad_request 
      end
    else
      render json: { error: 'Need to include the Authorization header' }, status: :forbidden # The header isn´t present
    end
  end
  
  def encodeJWT(user, exp=2.hours.from_now)
    # add the expire to the payload, as an integer
    payload = { user_id: user.id }
    payload[:exp] = exp.to_i
    
    # Encode the payload whit the application secret, and a more advanced hash method (creates header with JWT gem)
    JWT.encode( payload, Rails.application.secrets.secret_key_base, "HS256")
    
  end
  
  def decodeJWT(token)
   # puts token
    payload = JWT.decode(token, Rails.application.secrets.secret_key_base, "HS256")
   # puts payload
    if payload[0]["exp"] >= Time.now.to_i
      payload
    else
      puts "time fucked up"
      false
    end
    # catch the error if token is wrong
    rescue => error
      puts error
      nil
  end
  
  #def restrict_access
      #authenticate_or_request_with_http_token do |token, options|
          #App.exists?(apikey: token)
      #end
  #end
            
  protected
  
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
