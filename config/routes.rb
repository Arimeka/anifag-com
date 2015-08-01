Rails.application.routes.draw do
  root 'home#index'

  resources :articles, only: [:index, :show]
  resources :galleries, only: [:index, :show]
end
