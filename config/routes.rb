Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  get '/public', to: 'welcome#public'
  get '/logs/search', to: 'logs#search'

  resources :users, only: [:show]
  
  resources :boards do
    resources :logs
  end
end
