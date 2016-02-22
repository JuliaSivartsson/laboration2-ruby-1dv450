module Api
    module V1
        class TagsController < ApplicationController
            #http_basic_authenticate_with name: "admin", password: "hejsan"
            
            protect_from_forgery with: :null_session
            
            #Make sure apikey is present
            before_filter :restrict_access
            
            #Return response in json or xml
            respond_to :json, :xml
            
            #If user wants to set own offset and limit, these are defined in application_controller
            before_filter :offset_params, only: [:index, :nearby]
            
            # GET all tags /api/v1/tags
            def index
                #Limit and offset is set in application_controller
                tags = Tag.limit(@limit).offset(@offset)
                
                count_tags = Tag.distinct.count(:id)
                @response = {tags: tags, nrOfTags: count_tags}
                respond_with @response, include: [:restaurants], status: :ok
            end
            
            # GET one tag /api/v1/tags/:id
            def show
                tag = Tag.find_by_id(params[:id])
                 #If tag does exist
                if !tag.nil?
                    respond_with tag, include: [:restaurants], status: :ok
                else
                    respond_with message: "Resource not found", status: :not_found
                end
            end
            
            # POST create tag /api/v1/tags
            def create
                tag = Tag.new(tag_params)
                
                if tag.save
                   render json: tag, status: :created
                else
                    render json: tag.errors, status: :unprocessable_entity
                end
            end
            
            # DELETE one tags /api/v1/tags/:id
            def destroy
                tag = Tag.find_by_id(params[:id])
                 #If tag does exist
                if !tag.nil?
                    tag.destroy
                    head :no_content
                else
                    respond_with message: "Resource not found", status: :not_found
                end
            end
            
            # PUT update one tag /api/v1/tags/:id
            def update
                tag = Tag.find_by_id(params[:id])
                if tag.update(tag_params)
                   render json: tag, status: :ok
                else
                    respond_with tag.errors, status: :unprocessable_entity
                end
            end
            
            private
            def tag_params
                json_params = ActionController::Parameters.new( JSON.parse(request.body.read) )
                json_params.require(:tag).permit(:name)
            end
        end
    end
end
