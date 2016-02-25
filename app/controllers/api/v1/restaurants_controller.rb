module Api
    module V1
        class RestaurantsController < ApplicationController
            
            protect_from_forgery with: :null_session
            
            #Make sure apikey is present
            before_filter :restrict_access
            before_filter :offset_params, only: [:index]
            
            #For some functions we need to make sure user has logged in (using Knock)
            before_action :authenticate, only: [:create, :update, :delete]

            #Return response in json or xml
            respond_to :json, :xml
            
            # GET all restaurants /api/v1/restaurants
            def index
                
                restaurants = Restaurant.all.order("created_at DESC")
                
                if restaurants.present?
                    query_params = params[:query]
                    if query_params.present?
                        #Search for rating
                        if query_params.to_i != 0
                            restaurants = Restaurant.where(:rating => query_params)
                        else
                            #Search for name or message
                            restaurants = Restaurant.where("lower(name) like :search OR lower(message) like :search", search: "%#{query_params.downcase}%")
                        end
                        
                        #Offset and limit
                        restaurants = restaurants.drop(@offset)
                        restaurants = restaurants.take(@limit)
                        count_restaurants = restaurants.count
                        
                        @response = {:offset => @offset, :limit => @limit, restaurants: restaurants, nrOfRestaurants: count_restaurants}
                        respond_with @response, include: [:position, :tags], status: :ok
                    end
                    if params[:longitude] && params[:latitude]
                        nearby_locations = Position.near([params[:latitude], params[:longitude]], 50)
                        restaurants = []
                        nearby_locations.each do |loc|
                            restaurants.push(Restaurant.where(:position_id => loc.id))
                        end
                                                            
                        #Offset and limit
                        restaurants = restaurants.drop(@offset)
                        restaurants = restaurants.take(@limit)
                        count_restaurants = restaurants.count
                        
                        @response = {:offset => @offset, :limit => @limit, nearby_locations: nearby_locations, nrOfRestaurants: count_restaurants}
                        respond_with @response, include: [:restaurants], status: :ok
                    
                    elsif params[:address_and_city]
                        nearby_locations = Position.near(params[:address_and_city], 50)
                        restaurants = []
                        nearby_locations.each do |loc|
                            restaurants.push(Restaurant.where(:position_id => loc.id))
                        end
                                                                    
                        #Offset and limit
                        restaurants = restaurants.drop(@offset)
                        restaurants = restaurants.take(@limit)
                        count_restaurants = restaurants.count
                        
                        @response = {:offset => @offset, :limit => @limit, nearby_locations: nearby_locations, nrOfRestaurants: count_restaurants}
                        respond_with @response, include: [:restaurants], status: :ok
                    else
                        #Offset and limit
                        restaurants = restaurants.drop(@offset)
                        restaurants = restaurants.take(@limit)
                        count_restaurants = restaurants.count
                        
                        @response = {:offset => @offset, :limit => @limit, restaurants: restaurants, nrOfRestaurants: count_restaurants}
                        respond_with @response, include: [:position, :tags], status: :ok
                    end
                else
                    render json: {error: "Couldn't find any restaurants :(", status: :not_found}
                end
            end
            
            # GET one restaurant /api/v1/restaurants/:id
            def show
                restaurant = Restaurant.find_by_id(params[:id])
                
                #If restaurant does exist
                if !restaurant.nil?
                    respond_with restaurant, include: [:creator, :position, :tags], status: :ok
                else
                    respond_with message: "Resource not found", status: :not_found
                end
            end
            
            # POST create new restaurant and add tags /api/v1/restaurants
            def create
                restaurant = Restaurant.new(restaurant_params.except(:tags, :position))
                restaurant.creator_id = current_user.id
                
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
                    render json: { action: "destroy", message: "The restaurant '#{restaurant.name}' has been removed.", status: :ok}
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
