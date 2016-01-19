Rails.application.routes.draw do

  namespace :staff, path: '' do
    root 'top#index'
    get 'login' => 'sessions#new', as: :login
    resource :session, only: [ :create, :destroy ]
    resource :account, except: [ :new, :create, :destroy ] do
      patch :confirm
    end
    resource :password, only: [ :show, :edit, :update ]
    resources :customers
    resources :programs do
      patch :entries, on: :member
    end
    resources :messages, only: [ :index, :show, :destroy ] do
      get :inbound, :outbound, :deleted, :count, on: :collection
    end
  end

  namespace :admin do
    root 'top#index'
    get 'login' => 'sessions#new', as: :login
    resource :session, only: [ :create, :destroy ]
    resources :staff_members do
      resources :staff_events, only: [ :index ]
    end
    resources :staff_events, only: [ :index ]
    resources :allowed_sources, only: [ :index, :create ] do
      delete :delete, on: :collection
    end
  end

  namespace :customer do
    root 'top#index'
    get 'login' => 'sessions#new', as: :login
    resource :session, only: [ :create, :destroy ]
    resource :account, except: [ :new, :create, :destroy ] do
      patch :confirm
    end
    resources :programs, only: [ :index, :show ] do
      resources :entries, only: [ :create ] do
        patch :cancel, on: :member
      end
    end
    resources :messages, only: [ :new, :create ] do
      post :confirm, on: :collection
    end
  end

  root 'errors#routing_error'
  get '*anything' => 'errors#routing_error'
end
