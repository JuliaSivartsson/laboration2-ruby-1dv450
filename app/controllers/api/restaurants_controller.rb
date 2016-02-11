class Api::RestaurantsController < ApplicationController
    
    #Make sure apikey is present
    before_action :check_api_key
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
        @restaurant = Restaurant.new(params[:restaurant])
        
        if @restaurant.save
            render json: @restaurant, status: :created
        else
            render json: @restaurant.errors, status: :unprocessable_entity
        end
    end
    
    # GET /api/restaurants/:id
    def show
        @restaurant = Restaurant.find(params[:id])
        render json: @restaurant
    end
    
    # DELETE /api/restaurants/:id
    def destroy
        @restaurant.destroy
        
        head :no_content
    end
    
    # PUT /api/restaurants/:id
    def update
        if @restaurant.update(contact_params)
            head :no_content
        else
            render json: @restaurant.errors, status: :unprocessable_entity
        end
    end
end
