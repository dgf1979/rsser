Rails.application.routes.draw do
  root to: 'feeds#index'
  resources :feeds do
    member do
      get 'refresh'
    end
    resources :items, only: [:show, :update]
  end
  namespace :api do
    namespace :xml do
      resources :feed, only: [:index]
    end  
  end
end
