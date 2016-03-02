class Api::V1::TagsController < Api::V1::ApiController
    
    before_filter :offset_params, only: [:index]
    
    #For some functions we need to make sure user has logged in (using Knock)
    before_action :authenticate, only: [:create, :update, :delete]
    
    #If user wants to set own offset and limit, these are defined in application_controller
    before_filter :offset_params, only: [:index]
    
    # GET all tags /api/v1/tags
    def index
        
        if params[:restaurant_id].present?
            restaurant = Restaurant.find_by_id(params[:restaurant_id])
            tags = restaurant.tags
        else
            tags = Tag.all
        end
        if tags.present?
            #Offset and limit
            tags = tags.drop(@offset)
            tags = tags.take(@limit)
            count_tags = tags.count
            
            #@response = {:offset => @offset, :limit => @limit, tags: tags, nrOfTags: count_tags}
            respond_with tags, status: :ok
        else
            render json: {errors: "Couldn't find any tags" }, status: :not_found
        end
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
            render json: { error: "No tag with this id was found" }, status: :not_found
        end
    end
    
    # PUT update one tag /api/v1/tags/:id
    def update
        tag = Tag.find_by_id(params[:id])
        if tag.update(tag_params)
           render json: tag, status: :created
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