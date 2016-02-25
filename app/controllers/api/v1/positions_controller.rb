module Api
    module V1
        class PositionsController < ApplicationController
            
            protect_from_forgery with: :null_session
            
            #Make sure apikey is present
            before_filter :restrict_access
            
            #For some functions we need to make sure user has logged in (using Knock)
            before_action :authenticate, only: [:create, :update, :delete]
            
            #If user wants to set own offset and limit, these are defined in application_controller
            before_filter :offset_params, only: [:index, :nearby]
            
            #Return response in json or xml
            respond_to :json, :xml
            
            # GET all positions /api/v1/positions
            def index
                
                positions = Position.all
                
                #Offset and limit
                positions = positions.drop(@offset)
                positions = positions.take(@limit)
                count_positions = positions.count
                
                @response = {:offset => @offset, :limit => @limit, positions: positions, nrOfPositions: count_positions}
                respond_with @response, include: [:restaurants], status: :ok
            end
            
            # GET one positions /api/v1/positions/:id
            def show
                position = Position.find_by_id(params[:id])
                
                if !position.nil?
                    respond_with position, include: [:restaurants], status: :ok
                else
                    respond_with message: "Resource not found", status: :not_found
                end
            end
            
            # POST create positions /api/v1/positions
            def create
                position = Position.new(position_params)
                
                if position.save
                    render json: position, status: :created
                else
                    render json: position.errors, status: :unprocessable_entity
                end
            end
            
            # DELETE /api/v1/positions/:id
            def destroy
                position = Position.find_by_id(params[:id])
                 #If position does exist
                if !position.nil?
                    position.destroy
                    head :no_content
                else
                    respond_with message: "Resource not found", status: :not_found
                end
            end
            
            # PUT /api/v1/positions/:id
            def update
                position = Position.find_by_id(params[:id])
                if position.update(position_params)
                   render json: position, status: :ok
                else
                    respond_with position.errors, status: :unprocessable_entity
                end
            end
            
            #GET List nearby restaurants /api/v1/postions/:id/nearby
            def nearby
                # Check the parameters
                if params[:long].present? && params[:lat].present?
                  # using the parameters
                  nearby_positions = Position.near([params[:lat], params[:long]], 50)
                  
                  #Offset and limit
                  nearby_positions = nearby_positions.drop(@offset)
                  nearby_positions = nearby_positions.take(@limit)
                  count_positions = nearby_positions.count
                    
                  @response = {:offset => @offset, :limit => @limit, nearby_positions: nearby_positions, nrOfNearbyPosition: count_positions}
                  respond_with @response, include: [:restaurants], status: :ok
                else
                  render json: position.errors, status: :bad_request # just json in this example
                end
            end
  
            #Get params for creating new position
            def position_params
                json_params = ActionController::Parameters.new(JSON.parse(request.body.read))
                json_params.require(:position).permit(:address, :longitude, :latitude)
            end
        end
    end
end
