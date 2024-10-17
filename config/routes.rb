Rails.application.routes.draw do
  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Set the root of the app to the v1 namespace
  root to: redirect('/v1')

  namespace :v1 do
    get 'guidelines/index'
    root 'homes#index'
    get 'about', to: 'homes#about'
    get 'contact', to: 'homes#contact'
    resources :guidelines, only: [:index] do
      collection do
        get :complete, to: 'guidelines#complete', as: :mark_guideline_as_complete
      end
    end
    resources :branches do
      resources :medicines do
          collection do 
           get :expired_medicines
          end
        end
      resources :audit_logs
      resources :records do 
        member do
         get :dispatch_order
        end
        collection do
          get 'pending_orders'
          get 'delivered_orders'
          get 'get_medicines_for_branch'
        end
      end
      resources :stock_transfers do 
        member do
          post 'approve'
          patch :upload_pdf
        end
      end
      resources :users, only: [:index, :new, :create, :show]
    end
    resources :refunds do
      member do
        patch :approve 
        patch :deny 
        post :dispute
        get :dispute_form
      end
    end
    resources :notifications, only: [:index, :show]
    resources :records do
      member do
        get 'download_pdf'
      end
      collection do
        get 'customer_purchase', to: 'records#new_purchase', as: :customer_purchase
        post 'customer_purchase', to: 'records#customer_purchase'
        get :get_medicines_for_branch
        
        get 'customer_records', to: 'records#customer_records'
      end
    end
    resources :disputes, only: [:index, :show, :new, :create] do 
      member do
        patch :approve
        patch :deny
      end
    end

  end
  direct :rails_blob do |blob|
    { controller: 'active_storage/blobs', action: 'show', params: { signed_id: blob.signed_id, filename: blob.filename } }
  end
end
