# frozen_string_literal: true

require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  namespace :admins do
    resources :hotels, only: %i[index edit update] do
      resources :addresses, only: %i[new create destroy]
      resources :amenities
      resources :feedbacks, only: %i[index destroy]
      resources :hotel_galleries
      resources :offers
      resources :room_categories, except: :show
      resources :rooms do
        resources :room_bed_types, only: %i[create destroy]
        resources :room_facilities, only: %i[create destroy]
        resources :bookings, only: %i[new create] do
          member do
            get :confirm_booking
            patch :update_confirmation
          end
        end
      end
      resources :bookings, except: %i[new create]
      resources :bed_types, except: %i[index show]
      resources :facilities
      resources :employees
      resources :guests
    end
    resources :profiles, only: %i[index edit update]
  end

  devise_for :admins, skip: [:registrations], controllers: { sessions: 'admins/sessions' }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  constraints subdomain: /[a-zA-Z0-9]+/ do
    get '/', to: 'home#show', as: :home
    get '/explore', to: 'explore#index', as: :explore
  end

  root 'home#show'

  authenticated :admins do
    # mount Sidekiq::Web => '/sidekiq'
    root to: 'admins#index', as: :admin_root
  end

  get 'admins' => 'admins#index'

end
