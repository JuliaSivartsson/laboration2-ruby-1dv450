module Api
    module V1
        class RestaurantsController < ApplicationController
            #http_basic_authenticate_with name: "admin", password: "hejsan"
            
            
            #Make sure apikey is present
            before_filter :restrict_access
            
            #Return response in json or xml
            respond_to :json, :xml
            
            # GET /api/restaurants
            def index
                restaurants = Restaurant.all
                nr = Restaurant.distinct.count(:id)
                respond_with restaurants, status: :ok
            end
            
            # POST /api/restaurants
            def create
                restaurant = Restaurant.new(params[:restaurant])
                
                if restaurant.save
                    respond_with restaurant, status: :created
                else
                    respond_with restaurant.errors, status: :unprocessable_entity
                end
            end
            
            # GET /api/restaurants/:id
            def show
                restaurant = Restaurant.find(params[:id])
                respond_with restaurant
            end
            
            # DELETE /api/restaurants/:id
            def destroy
                restaurant.destroy
                
                head :no_content
            end
            
            # PUT /api/restaurants/:id
            def update
                if restaurant.update(contact_params)
                    head :no_content
                else
                    respond_with restaurant.errors, status: :unprocessable_entity
                end
            end
            
            private
            
            def restrict_access
                api_key = App.find_by_apikey(params[:access_token])
                head :unauthorized unless api_key
            end
            
            #def restrict_access
                #authenticate_or_request_with_http_token do |token, options|
                    #App.exists?(apikey: token)
                #end
            #end
        end
    end
end
