Rails.application.routes.draw do

  namespace :staff, path: '' do
    root 'top#index'
    get 'login' => 'sessions#new', as: :login
    resource :session, only: [ :create, :destroy ]
    resource :account, except: [ :new, :create, :destroy ]
    resource :password, only: [ :show, :edit, :update ]
    resources :customers
    resources :programs
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
  end

  root 'errors#routing_error'
  get '*anything' => 'errors#routing_error'
end
