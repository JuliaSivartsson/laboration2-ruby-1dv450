class Api::V1::ApiController < ApplicationController
    protect_from_forgery with: :null_session
    
    #Make sure apikey is present
    before_filter :restrict_access
    
    #Return response in json or xml
    respond_to :json, :xml
    
  #after_filter :cors_set_access_control_headers

    # For all responses in this controller, return the CORS access control headers.
    
   # def cors_set_access_control_headers
#        headers['Access-Control-Allow-Origin'] = '*'
#        headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS, DELETE, PUT'
#        headers['Access-Control-Request-Method'] = '*'
#        headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
#        headers['Access-Control-Max-Age'] = "5000";
#    end
end