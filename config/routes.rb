Rails.application.routes.draw do
  root to: 'feeds#index'
  resources :feeds do
    member do
      get 'refresh'
    end
  end
end
