module Api
    module V1
        class TagsController < ApplicationController
            #http_basic_authenticate_with name: "admin", password: "hejsan"
            
            
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
                respond_with @response, status: :ok
            end
            
            # POST create tag /api/v1/tags
            def tags
                tag = Tag.new(params[:name])
                
                if tag.save
                    respond_with tag, status: :created
                else
                    respond_with tags.errors, status: :unprocessable_entity
                end
            end
            
            # GET one tag /api/v1/tags/:id
            def show
                tag = Tag.find(params[:id])
                respond_with tag
            end
            
            # DELETE one tags /api/v1/tags/:id
            def destroy
                tag.destroy
                
                head :no_content
            end
            
            # PUT update one tag /api/v1/tags/:id
            def update
                if tag.update(contact_params)
                    head :no_content
                else
                    respond_with tag.errors, status: :unprocessable_entity
                end
            end
        end
    end
end
