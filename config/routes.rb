Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'api/erp/login',
    sign_out: 'api/erp/logout',
    registration: 'api/erp/signup'
  },
  controllers: {
    sessions: 'api/erp/users/sessions',
    registrations: 'api/erp/users/registrations',
    logout: 'api/erp/users/logout'
  }

  namespace :api, defaults: { format: :json } do
    namespace :erp do
      resources :categories, only: %i[create show update destroy index]
      resources :subcategories, only: %i[create show update destroy index]
      resources :products, only: %i[index create show destroy update]
      resources :orders, only: %i[index create show destroy update]
      resources :order_products, only: %i[create destroy update]
      resources :customers, only: %i[index create show destroy update]
      resources :stock_histories, only: %i[index create destroy]
      resources :me, only: :index
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
