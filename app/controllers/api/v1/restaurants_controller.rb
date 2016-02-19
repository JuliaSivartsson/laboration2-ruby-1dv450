module Api
    module V1
        class RestaurantsController < ApplicationController
            #http_basic_authenticate_with name: "admin", password: "hejsan"
            protect_from_forgery with: :null_session
            
            #Make sure apikey is present
            before_filter :restrict_access
            
            #For some functions we need to make sure user sends in loggin stuff
            before_filter :authenticate, only: [:create, :update, :delete]
            
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
                restaurant = Restaurant.new(restaurant_params.except(:tags, :positions))
            
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
                if restaurant_params[:positions].present?
                    position_params = restaurant_params[:positions]
                    
                    position_params.each do |position|
                        #If position already exists then just add a reference to it
                        if Position.exists?(position)
                            this_position = Position.find_by_address(position["address"])
                            restaurant.position_id = this_position.id
                            restaurant.save
                        else
                            #HOW DO I GET IT TO CREATE A NEW POSITION?!
                            new_position = Position.new(position)
                            find_position = Position.find_by_address(position["address"])
                            restaurant.position_id = find_position.id
                            restaurant.save
                        end
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
                restaurant = Restaurant.find_by_id(params[:id])
                if restaurant.update(params.permit(:name, :message, :rating, :position_id))
                   render json: restaurant, status: :ok
                else
                    respond_with restaurant.errors, status: :unprocessable_entity
                end
            end
            
            private
            
            #Get params for creating new restaurant
            def restaurant_params
                json_params = ActionController::Parameters.new(JSON.parse(request.body.read))
                json_params.require(:restaurant).permit(:name, :message, :rating, tags: [:name], positions: [:address])
            end
        end
    end
end
