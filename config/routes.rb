Rails.application.routes.draw do
  resources :cities
  resources :information
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
