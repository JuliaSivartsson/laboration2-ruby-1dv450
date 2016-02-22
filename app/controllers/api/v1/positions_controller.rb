module Api
    module V1
        class PositionsController < ApplicationController
            #http_basic_authenticate_with name: "admin", password: "hejsan"
            
            protect_from_forgery with: :null_session
            
            #Make sure apikey is present
            before_filter :restrict_access
            
            #Return response in json or xml
            respond_to :json, :xml
            
            # GET all positions /api/v1/positions
            def index
                #Limit and offset is set in application_controller
                positions = Position.limit(@limit).offset(@offset)
                
                count_positions = Position.distinct.count(:id)
                @response = {positions: positions, nrOfPositions: count_positions}
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
                  # using the parameters and offset/limit
                  nearby_positions = Position.near([params[:lat].to_f, params[:long].to_f], 30).limit(@limit).offset(@offset)
                  respond_with nearby_positions, include: [:restaurants], status: :ok
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
