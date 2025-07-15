Rails.application.routes.draw do
  get "home/index"
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
 
  get "up" => "rails/health#show", as: :rails_health_check


  get 'service_provider/service_details', to: 'service_providers#service_details', as: :service_provider_details

  patch "/service_providers/professional_details", to: "service_providers#update_professional_details", as: "update_professional_details"

  

get "/location_form", to: "service_providers#location_form", as: :location_form

patch "/location", to: "service_providers#update_location", as: "update_location"

get 'update_subcategories', to: 'service_providers#update_subcategories'


root to: 'home#index'
end
