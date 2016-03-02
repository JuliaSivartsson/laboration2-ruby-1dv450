class Api::V1::RestaurantsController < Api::V1::ApiController

    before_filter :offset_params, only: [:index]
    
    #For some functions we need to make sure user has logged in (using Knock)
    before_action :authenticate, only: [:create, :update, :destroy]
    
    # GET all restaurants /api/v1/restaurants
    def index
        
        #restaurants = Restaurant.all.order("created_at DESC")
        
        #Show based on tags
        if params[:tag_id].present?
          tag = Tag.find_by_id(params[:tag_id])
          restaurants = tag.restaurants
          
        #Show based on location
        elsif params[:position_id].present?
          position = Position.find_by_id(params[:position_id])
          restaurants = position.restaurants
            
        #Show based on creator
        elsif params[:creator_id].present?
          creator = Creator.find_by_id(params[:creator_id])
          restaurants = creator.restaurants
          
        #If ?query= is in url
        elsif params[:query].present?
            #Search for rating
            if params[:query].to_i != 0
                restaurants = Restaurant.where(:rating => params[:query])
            else
                #Search for name or message
                restaurants = Restaurant.where("lower(name) like :search OR lower(message) like :search", search: "%#{params[:query].downcase}%")
            end
            
            if restaurants.exists?
                #Offset and limit
                restaurants = restaurants.drop(@offset)
                restaurants = restaurants.take(@limit)
                count_restaurants = restaurants.count
                
                @response = {:offset => @offset, :limit => @limit, restaurants: restaurants, nrOfRestaurants: count_restaurants}
                respond_with @response, include: [:position, :tags], status: :ok
            else
               respond_with ( message = { error: "Resource not found"} ), :status => :not_found
            end
            
        #If lat and long is in url
        elsif params[:longitude] && params[:latitude]
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
        
        #If anddress_and_city is in url
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
        
        #If no parameters are in url
        elsif
        
            restaurants = Restaurant.all.order("created_at DESC")

        end
        
        if restaurants.present?
                        
            #Offset and limit
            restaurants = restaurants.drop(@offset)
            restaurants = restaurants.take(@limit)
            count_restaurants = restaurants.count
            
            #@response = {:offset => @offset, :limit => @limit, restaurants: restaurants, nrOfRestaurants: count_restaurants}
            respond_with restaurants, status: :ok
        else
            render json: {error: "Couldn't find any restaurants :(", status: :not_found}
        end
    end
    
    # GET one restaurant /api/v1/restaurants/:id
    def show
        restaurant = Restaurant.find_by_id(params[:id])
        
        #If restaurant does exist
        if !restaurant.nil?
            respond_with restaurant, status: :ok
        else
            render json: { error: "Resource not found"}, status: :not_found
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
         #If restaurant does exist for current user
        if !(restaurant = @current_user.restaurants.find_by_id(params[:id])).nil?
            
            #If a tag only has this restaurant connected to it, then remove it
            restaurant.tags.each do |tag|
                if tag.restaurants.size == 1
                    tag.destroy
                end
            end
            
            #If a position only has this restaurant connected to it, then remove it
            position = restaurant.position
            if position.restaurants.size == 1
                position.destroy
            end
                
            restaurant.destroy
            render json: { action: "destroy", message: "The restaurant '#{restaurant.name}' has been removed.", status: :ok}
        else
            render json: { error: "No restaurant with this id was found" }, status: :not_found
        end
    end
    
    # PUT update one restaurant /api/v1/restaurants/:id
    def update
        if !(restaurant = @current_user.restaurants.find_by_id(params[:id])).nil?
            
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
            
            if restaurant.update(restaurant_params)
               render json: restaurant, status: :created
            else
                respond_with restaurant.errors, status: :unprocessable_entity
            end
        else
            render json: { error: "No restaurant with this id was found" }, status: :not_found
        end
    end
    
    private
    
    #Get params for creating new restaurant
    def restaurant_params
        json_params = ActionController::Parameters.new(JSON.parse(request.body.read))
        json_params.require(:restaurant).permit(:name, :message, :rating, tags: [:name], position: [:address])
    end
end