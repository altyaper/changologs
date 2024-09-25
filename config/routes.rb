require 'constraints/subdomain_constraint'
Rails.application.routes.draw do
  draw :auth
  draw :api
  draw :logs
  draw :boards
  draw :users
  draw :api_clients
  constraints SubdomainConstraint.new do
    get '/', to: 'sites#show'
  end
  root 'boards#index'
end
