class Api::V1::ApiController < ApplicationController
    protect_from_forgery with: :null_session
    
    #Make sure apikey is present
    before_filter :restrict_access
    
    #Return response in json or xml
    respond_to :json, :xml
end