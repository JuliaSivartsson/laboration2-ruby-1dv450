class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_cache_buster
  
  
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
  
  #Check for api-key
  def restrict_access
    api_key = App.find_by_apikey(params[:access_token])
    
    #If key does not exist
    unless api_key
      render json: { message: "The API-key was not valid"}, status: :unauthorized
    end
  end
  
  #API authentication with JWT
  def api_authenticate
    
    #Is there any Authorization in the header
    if request.headers["Authorization"].present?
      auth_header = request.headers['Authorization'].split(' ').last
      @token_payload = decodeJWT auth_header.strip
      if !@token_payload
        render json: { error: 'The provided token wasn´t correct' }, status: :bad_request 
      end
    else
      render json: { error: 'Need to include the Authorization header' }, status: :forbidden
    end
  end
  
  #Found help here:
  #http://adamalbrecht.com/2015/07/20/authentication-using-json-web-tokens-using-rails-and-react/    
      
  #Send in logged in user and encode it into a JWT Token
  def authentication_payload(user)
      return nil unless user && user.id
      {
        auth_token: encodeJWT({ user_id: user.id }),
        user: { id: user.id, username: user.name } # return whatever user info you need
      }
  end
  
  #Encode a hash in a json web token
  def encodeJWT(payload, ttl_in_minutes = 60 * 24 * 30)
    payload[:exp] = ttl_in_minutes.minutes.from_now.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  #Decode a token and return the payload inside
  def decodeJWT(token, leeway = nil)
    decoded = JWT.decode(token, Rails.application.secrets.secret_key_base, leeway: leeway)
    HashWithIndifferentAccess.new(decoded[0])
  end
  
  protected
  
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
