Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root 'homes#index'

  resources :branches do

    resources :medicines
    resources :audit_logs
    resources :records
    resources :stock_transfers do 
      member do
        post 'approve'
        patch :upload_pdf
      end
    end
    resources :users
  end
  resources :notifications, only: [:index, :show]

  # Defines the root path route ("/")
  # root "posts#index"
end
