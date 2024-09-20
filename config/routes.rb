Rails.application.routes.draw do
  # Devise route configurations
  devise_for :users, path: 'auth', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root 'boards#index'
  
  # 2FA
  get 'enable_otp_show_qr', to: 'users#enable_otp_show_qr', as: 'enable_otp_show_qr'
  post 'enable_otp_verify', to: 'users#enable_otp_verify', as: 'enable_otp_verify'
  
  get 'users/otp', to: 'users#show_otp', as: 'user_otp'
  post 'users/otp', to: 'users#verify_otp', as: 'verify_user_otp'
  post 'verify_otp', to: 'users/sessions#verify_otp'
  

  get '/logs/search', to: 'logs#search'
  get '/users/:user_id/friend', to: 'users#friend_request'
  get '/profile', to: 'users#show'
  get '/shared', to: 'boards#shared'
  
  scope 'api' do
    get '/users/search_friends', to: 'users#search_friends'
    get '/friends', to: 'friendship#index'
    post '/friends', to: 'friendship#friendship'
    post '/boards/share', to: 'boards#share'
    resources :friend_requests
  end
  
  resources :api_clients, only: [:index, :create] do
    # Add a custom member route for regenerating the API key
    member do
      put 'regenerate', to: 'api_clients#regenerate'
    end
  end
  resources :friends, :user_board
  resources :boards do
    resources :logs
  end
end
