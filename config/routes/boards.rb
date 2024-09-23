get '/shared', to: 'boards#shared'

resources :boards do
  resources :logs do
    member do
      post 'publish'
    end
  end
end