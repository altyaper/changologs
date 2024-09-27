require 'constraints/subdomain_constraint'
Rails.application.routes.draw do
  constraints SubdomainConstraint.new do
    get '/', to: 'sites#show'
  end
  draw :auth
  draw :api
  draw :logs
  draw :boards
  draw :users
  draw :api_clients
  root 'boards#index'
end
