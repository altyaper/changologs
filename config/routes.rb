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
