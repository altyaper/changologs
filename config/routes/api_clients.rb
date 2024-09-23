resources :api_clients, only: [:index, :create] do
  # Add a custom member route for regenerating the API key
  member do
    put 'regenerate', to: 'api_clients#regenerate'
  end
end
