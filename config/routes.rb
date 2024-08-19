Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

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
