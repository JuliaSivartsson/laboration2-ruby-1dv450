module Api
    module V1
        class RestaurantsController < ApplicationController
            #http_basic_authenticate_with name: "admin", password: "hejsan"
            
            
            #Make sure apikey is present
            before_filter :restrict_access
            
            #Return response in json or xml
            respond_to :json, :xml
            
            # GET all restaurants /api/v1/restaurants
            def index
                #Limit and offset is set in application_controller
                restaurants = Restaurant.limit(@limit).offset(@offset)
                
                count_restaurants = Restaurant.distinct.count(:id)
                @response = {restaurants: restaurants, nrOfRestaurants: count_restaurants}
                respond_with @response, include: [:position, :tags], status: :ok
            end
            
            # GET one restaurant /api/v1/restaurants/:id
            def show
                restaurant = Restaurant.find_by_id(params[:id])
                
                #If restaurant does exist
                if !restaurant.nil?
                    respond_with restaurant, include: [:position, :tags], status: :ok
                else
                    respond_with message: "Resource not found", status: :not_found
                end
            end
            
            # POST create new restaurant and add tags /api/v1/restaurants
            def create
                restaurant = Restaurant.new(restaurant_params.exept(:tags))
                #Check that params for tags are present
                if restaurant_params[:tags].present?
                    tags_params = restaurant_params[:tags]
                    tags_params.each do |tag|
                        #If tag already exists
                        if Tag.exists?(tag[:name])
                            restaurant.tags << tag
                        else
                            restaurant.tags << Tag.new(tag)
                        end
                    end
                end
                
                if restaurant.save
                    respond_with restaurant, status: :created
                else
                    respond_with restaurant.errors, status: :unprocessable_entity
                end
            end
            
            # DELETE one restaurant /api/v1/restaurants/:id
            def destroy
                restaurant.destroy
                
                head :no_content
            end
            
            # PUT update one restaurant /api/v1/restaurants/:id
            def update
                if restaurant.update(contact_params)
                    head :no_content
                else
                    respond_with restaurant.errors, status: :unprocessable_entity
                end
            end
            
            private
            
            #Get params for creating new restaurant
            def restaurant_params
                json_params = ActionController::Parameters.new(JSON.parse(request.body.read))
                json_params.require(:restaurant).permit(:name, :message, :rating, tags:[:message, :name, :rating])
            end
        end
    end
end
