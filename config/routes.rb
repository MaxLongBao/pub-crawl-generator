Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :crawls, only: [:index, :show, :create] do
    member do
      patch 'save_for_later'
    end
  end
end
