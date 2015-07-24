Rails.application.routes.draw do
  root to: 'feeds#index'
  get 'feeds/new_bulkload', to: 'feeds#new_bulkload'
  post 'feeds/bulkload', to: 'feeds#bulkload'
  resources :feeds do
    member do
      get 'refresh'
      post 'bulkload'
    end
    resources :items, only: [:show, :update]
  end
  namespace :api do
    namespace :xml do
      resources :feed, only: [:index]
    end
  end
end
