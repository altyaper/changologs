Rails.application.routes.draw do
  draw :auth
  draw :api
  draw :logs
  draw :boards
  draw :users
  draw :api_clients
  root 'boards#index'
end
