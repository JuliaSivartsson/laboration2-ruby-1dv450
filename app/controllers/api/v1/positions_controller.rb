module Api
    module V1
        class PositionsController < ApplicationController
            #http_basic_authenticate_with name: "admin", password: "hejsan"
            
            
            #Make sure apikey is present
            before_filter :restrict_access
            
            #Return response in json or xml
            respond_to :json, :xml
            
            # GET all positions /api/v1/positions
            def index
                #Limit and offset is set in application_controller
                positions = Position.limit(@limit).offset(@offset)
                
                count_positions = Positon.distinct.count(:id)
                @response = {positions: positions, nrOfPositions: count_positions}
                respond_with @response, status: :ok
            end
            
            # GET one positions /api/v1/positions/:id
            def show
                position = Position.find_by_id(params[:id])
                
                if !position.nil?
                    respond_with position, status: :ok
                else
                    respond_with position.errors, status: :not_found
                end
            end
            
            # POST create positions /api/v1/positions
            def create
                position = Position.new(params[:restaurant])
                
                if restaurant.save
                    respond_with position, status: :created
                else
                    respond_with position.errors, status: :unprocessable_entity
                end
            end
            
            # DELETE /api/v1/positions/:id
            def destroy
                position.destroy
                
                head :no_content
            end
            
            # PUT /api/v1/positions/:id
            def update
                if position.update(contact_params)
                    head :no_content
                else
                    respond_with position.errors, status: :unprocessable_entity
                end
            end
        end
    end
end
