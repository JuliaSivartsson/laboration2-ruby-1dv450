Rails.application.routes.draw do
  mount Knock::Engine => "/knock"
  
  #THIS IS FOR LABORATION1
    root 'sessions#login'
  
  get "apps" => "apps#new"
  get "deleteapp" => "apps#delete_application"
    
  get "home" => "sessions#home"
  get "signup" => "users#new"
  get "login" => "sessions#login"
  get "logout" => "sessions#logout"
  get "profile" => "sessions#profile"

  
  get ':controller(/:action(/:id))(.:format)'
  post ':controller(/:action(/:id))(.:format)'
  
  
  #THIS IS FOR LABORATION2
  
  #Add /api/v1 before URI
namespace :api, :defaults => { :format => :json} do
    namespace :v1 do
        get "/restaurants" => "restaurants#index"
        post "/restaurants" => "restaurants#create"
        
        get "/restaurants/:id" => "restaurants#show"
        put "/restaurants/:id" => "restaurants#update"
        delete "/restaurants/:id" =>"restaurants#destroy"
        
        resources :positions
        get "/positions/nearby/:long/:lat" => "positions#nearby"
        resources :tags
        
        resources :creators, only: [:show, :index, :create, :new, :destroy, :update] do
          resources :restaurants, only: [:index]
        end
    end
end

#Callback from omniauth
#get "/auth/github/callback" => "sessions#create"
  
end
