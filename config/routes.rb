Rails.application.routes.draw do
  
  mount_avo
  get "home/index"
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'  
  }

  
  get "up" => "rails/health#show", as: :rails_health_check

  get '/provider_dashboard', to: 'service_providers#dashboard', as: 'provider_dashboard'

  patch '/update_booking_status/:id', to: 'service_providers#update_booking_status', as: 'update_booking_status'


  # PayFast routes
  get '/payfast/return', to: 'payfast#return'
  get '/payfast/cancel', to: 'payfast#cancel'
  post '/payfast/notify', to: 'payfast#notify'

  get "/create_services", to: "service_providers#create_services_form", as: :create_services
  
  post "/create_services", to: "service_providers#create_services"

  get 'service_provider/service_details', to: 'service_providers#service_details', as: :service_provider_details

  patch "/service_providers/professional_details", to: "service_providers#update_professional_details", as: "update_professional_details"

  get '/dashboard', to: 'client_dashboard#index', as: 'client_dashboard'
  
  get 'categories', to: 'categories#index'

  get 'categories/:category', to: 'categories#show', as: 'category_subcategories'

  get 'categories/:category/:subcategory/services', to: 'services#index', as: 'subcategory_services' 

  get 'services/:id', to: 'services#show', as: 'service'

  resources :bookings, only: [:edit, :update, :destroy]

  resources :services do
    resources :bookings, only: [:new, :create]
  end

  
  get 'all_users', to: 'home#all_users'

  get "/location_form", to: "service_providers#location_form", as: :location_form

  patch "/location", to: "service_providers#update_location", as: "update_location"

  get "/update_subcategories", to: "service_providers#update_subcategories", as: :update_subcategories


  



  root to: 'home#index'
end
