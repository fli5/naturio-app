Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Customer 使用独立的 Devise 路由
  devise_for :customers, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    sign_up: 'register'
  }

namespace :customers do
  resources :addresses, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :orders, only: [:index, :show]
end



  # 其他路由...
  root 'home#index'

  # ============================================
  # Products (Feature 2.1, 2.2, 2.3, 2.4, 2.5, 2.6)
  # ============================================
  resources :products, only: [:index, :show]

  # ============================================
  # Categories
  # ============================================
  resources :categories, only: [:index, :show]

  # ============================================
  # Static Pages (Feature 1.4 - About/Contact)
  # ============================================
  get '/pages/:slug', to: 'pages#show', as: :page

  # ============================================
  # Shopping Cart (Week 6)
  # ============================================
  resource :cart, only: [:show] do
    post 'add/:product_id', to: 'carts#add', as: :add_to
    patch 'update/:product_id', to: 'carts#update', as: :update_item
    delete 'remove/:product_id', to: 'carts#remove', as: :remove_from
    delete 'clear', to: 'carts#clear', as: :clear
  end

  # ============================================
  # Checkout & Orders (Week 7)
  # ============================================
  resource :checkout, only: [:show, :create] do
    get 'address', to: 'checkouts#address'
    post 'address', to: 'checkouts#save_address'
    get 'review', to: 'checkouts#review'
    get 'confirmation', to: 'checkouts#confirmation'
  end

  # ============================================
  # Customer Orders (Feature 3.2.1)
  # ============================================
  namespace :customer do
    resources :orders, only: [:index, :show]
    resources :addresses, except: [:show]
  end

  # ============================================
  # Payments Webhook (Week 8)
  # ============================================
  post '/webhooks/stripe', to: 'webhooks#stripe'

  # ============================================
  # Health Check (for deployment)
  # ============================================
  get '/health', to: proc { [200, {}, ['OK']] }
end
