Rails.application.routes.draw do
  namespace :admin do
    get "offers/index"
    get "offers/show"
    get "offers/new"
    get "offers/edit"
    get "offers/create"
    get "offers/update"
    get "offers/destroy"
    resources :hotels, only: [ :index, :edit, :update ] do
      resources :addresses, only: [ :new, :create, :destroy ]
      resources :amenities
      resources :feedbacks, only: [ :index, :destroy ]
      resources :hotel_galleries
      resources :offers
    end
    resources :profiles, only: [ :index, :edit, :update ]
  end
  devise_for :admins, skip: [ :registrations ], controllers: { sessions: "admin/sessions" }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  authenticated :admins do
    root to: "admin#index", as: :admin_root
  end

  get "admin" => "admin#index"
end
