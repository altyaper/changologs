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

  # 2FA
  get 'enable_otp_show_qr', to: 'users#enable_otp_show_qr', as: 'enable_otp_show_qr'
  post 'enable_otp_verify', to: 'users#enable_otp_verify', as: 'enable_otp_verify'

  get 'users/otp', to: 'users#show_otp', as: 'user_otp'
  post 'users/otp', to: 'users#verify_otp', as: 'verify_user_otp'
  post 'verify_otp', to: 'users/sessions#verify_otp'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'boards#index'

  get '/logs/search', to: 'logs#search'
  get '/users/:user_id/friend', to: 'users#friend_request'
  get '/profile', to: 'users#show'
  
  scope 'api' do
    get '/users/search_friends', to: 'users#search_friends'
    get '/friends', to: 'friendship#index'
    post '/friends', to: 'friendship#friendship'
    post '/boards/share', to: 'boards#share'
    resources :friend_requests
  end
  
  resources :friends
  resources :user_board
  resources :boards do
    resources :logs
  end
end
