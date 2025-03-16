Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :erp do
      resources :login, only: [:create]
      resources :products, only: [:index, :show]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
