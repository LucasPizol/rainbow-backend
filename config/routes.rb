Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :erp do
      resources :login, only: [:create]
      resources :categories, only: %i[create show update destroy index]
      resources :subcategories, only: %i[create show update destroy index]
      resources :products, only: %i[index create show destroy update]
      resources :orders, only: %i[index create show destroy update]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
