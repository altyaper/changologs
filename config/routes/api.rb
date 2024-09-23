scope 'api' do
  get '/users/search_friends', to: 'users#search_friends'
  get '/friends', to: 'friendship#index'
  post '/friends', to: 'friendship#friendship'
  post '/boards/share', to: 'boards#share'
  resources :friend_requests
end