Rails.application.routes.draw do
  get 'articles/new'
  get 'articles/create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'welcome#index'

  resources :articles
end
