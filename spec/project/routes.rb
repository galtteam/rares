# this is the router file
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
    end
  end
  resources :users
  root 'welcome'
end
puts Dir.pwd
