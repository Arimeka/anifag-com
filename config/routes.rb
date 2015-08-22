Rails.application.routes.draw do
  root 'home#index'

  resources :articles, only: [:index, :show] do
    collection { get 'page/:page', to: 'articles#index_page' }
  end
  resources :galleries, only: [:index, :show]
  resources :videos, only: [:index, :show]

  namespace :backend do
    root 'dashboard#index'

    resources :articles, except: :show

    get '/tags/:taggable', to: 'tags#search', format: :json
  end
end
