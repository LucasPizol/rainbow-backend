Rails.application.routes.draw do
  devise_for :clients
  devise_for :customers
  devise_for :users, path: '', path_names: {
    sign_in: 'api/erp/login',
    sign_out: 'api/erp/logout',
    registration: 'api/erp/signup',
  },
  controllers: {
    sessions: 'api/erp/users/sessions',
    registrations: 'api/erp/users/registrations',
    logout: 'api/erp/users/logout'
  },
  defaults: { format: :json }

  get "/", to: "web/home#index"
  get 'busca', to: 'web/search#index', as: :search

  namespace :api, defaults: { format: :json }, constraints: { id: /\d+/ } do
    namespace :erp do
      resources :categories, only: %i[create show update destroy index]
      resources :subcategories, only: %i[create show update destroy index]
      resources :products, only: %i[index create show destroy update] do
        collection do
          resources :names, only: :index, module: :products
        end
      end

      resources :orders, only: %i[index create show destroy update] do
        collection do
          resources :status, only: :index, module: :orders
        end
      end
      resources :order_products, only: %i[create destroy update]

      namespace :reports do
        resources :average_ticket, only: :index
        resources :in_out, only: :index
        resources :summary, only: :index
      end

      resources :customers, only: %i[index create show destroy update] do
        collection do
          resources :names, only: :index, module: :customers
        end
      end

      resources :stock_histories, only: %i[index create destroy]
      resources :me, only: :index
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
