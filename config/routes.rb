Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :crawls, only: [:index, :show, :create, :destroy] do
    member do
      patch 'save_for_later'
      patch 'pub_crawl_done'
    end
  end
end
