Rails.application.routes.draw do
  root 'home#index'

  resources :articles, only: [:index, :show] do
    collection { get 'page/:page', to: 'articles#index_page' }
  end
  resources :galleries, only: [:index, :show]
  resources :videos, only: [:index, :show] do
    collection { get 'page/:page', to: 'videos#index_page' }
  end

  namespace :backend do
    root 'dashboard#index'

    resources :articles, except: :show

    namespace :videos do
      resources :articles, except: :show
    end

    namespace :galleries do
      resources :articles, except: [:show, :create] do
        member do
          post  'upload', to: 'articles#upload',  as: :upload
          put   'sort',   to: 'articles#sort',    as: :sort
        end
      end
    end

    get '/tags/:taggable', to: 'tags#search', format: :json
  end
end
