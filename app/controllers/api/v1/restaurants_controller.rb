module Api
    module V1
        class RestaurantsController < ApplicationController
            
            protect_from_forgery with: :null_session
            
            #Make sure apikey is present
            before_filter :restrict_access
            before_filter :offset_params, only: [:index]
            
            #For some functions we need to make sure user has a JWT token
            before_filter :api_authenticate, only: [:create, :update, :delete]

            #Return response in json or xml
            respond_to :json, :xml
            
            # GET all restaurants /api/v1/restaurants
            def index
                #Limit and offset is set in application_controller
                restaurants = Restaurant.limit(@limit).offset(@offset).order("created_at DESC")
                
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
                restaurant = Restaurant.new(restaurant_params.except(:tags, :position))
                
                #Check if params for tags are present
                if restaurant_params[:tags].present?
                    tags_params = restaurant_params[:tags]
                    
                    tags_params.each do |tag|
                        #If tag already exists then just add a reference between that tag and restaurant
                        if Tag.exists?(tag)
                            restaurant.tags << Tag.find_by_name(tag["name"])
                        else
                            restaurant.tags << Tag.new(tag)
                        end
                    end
                end
                
                #Check if params for position are present
                if restaurant_params[:position].present?
                    position = restaurant_params[:position]
                    
                    #If position already exists then just add a reference to it
                    if Position.exists?(position)
                        this_position = Position.find_by_address(position["address"])
                        restaurant.position_id = this_position.id
                        restaurant.save
                    else
                        #If position does not exists, create a new one
                        new_position = Position.new(position)
                        new_position.save
                        restaurant.position_id = new_position.id
                        restaurant.save
                    end
                end
                
                if restaurant.save
                    render json: restaurant, status: :created
                else
                    render json: restaurant.errors, status: :unprocessable_entity
                end
            end
            
            # DELETE one restaurant /api/v1/restaurants/:id
            def destroy
                restaurant = Restaurant.find_by_id(params[:id])
                 #If restaurant does exist
                if !restaurant.nil?
                    restaurant.destroy
                    head :no_content
                else
                    respond_with message: "Resource not found", status: :not_found
                end
            end
            
            # PUT update one restaurant /api/v1/restaurants/:id
            def update
                if restaurant = Restaurant.find_by_id(params[:id])
                    
                    #Check if params for tags are present
                    if restaurant_params[:tags].present?
                        
                        tags_params = restaurant_params[:tags]
                        
                        tags_params.each do |tag|
                            #If tag already exists then just add a reference between that tag and restaurant
                            if Tag.exists?(tag)
                                restaurant.tags << Tag.find_by_name(tag["name"])
                            else
                                restaurant.tags << Tag.new(tag)
                            end
                        end
                    end
                    
                    if restaurant.save(restaurant_params)
                       render json: restaurant, status: :ok
                    else
                        respond_with restaurant.errors, status: :unprocessable_entity
                    end
                else
                    render json: { error: "No restaurant with this id was found" }, status: :bad_request
                end
            end
            
            private
            
            #Get params for creating new restaurant
            def restaurant_params
                json_params = ActionController::Parameters.new(JSON.parse(request.body.read))
                json_params.require(:restaurant).permit(:name, :message, :rating, tags: [:name], position: [:address])
            end
        end
    end
end
