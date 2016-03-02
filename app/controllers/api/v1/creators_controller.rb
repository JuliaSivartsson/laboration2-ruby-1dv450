module Api
    module V1
        class CreatorsController < ApiController
            
            before_filter :offset_params, only: [:index]
            
            #For some functions we need to make sure user has a JWT token
            before_filter :api_authenticate, only: [:create, :update, :delete]
            
            def show
                creator = Creator.find_by_id(params[:id])
                
                if creator.present?
                    respond_with creator, status: :ok
                else
                    render json: {error: "The creator could not be found"}, status: :not_found
                end
            end
            
            def index
                creators = Creator.limit(@limit).offset(@offset).order("created_at DESC")
                
                count_creators = Creator.distinct.count(:id)
                @response = {creators: creators, nrOfCreators: count_creators}
                respond_with @response, status: :ok
            end
            
        end
    end
end
