Rails.application.routes.draw do
  root 'home#index'

  resources :articles, only: [:index, :show]
  resources :galleries, only: [:index, :show]
  resources :videos, only: [:index, :show]

  namespace :backend do
    root 'dashboard#index'

    resources :articles, except: :show
  end
end
