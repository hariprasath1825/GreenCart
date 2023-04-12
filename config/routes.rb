Rails.application.routes.draw do
  use_doorkeeper

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users , controllers:{
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root 'home#index'
  get 'home/index'


  resources :product do
    resources :cart, only: :new
  end

  resources :seller

  resources :customer
  get 'order/order_history'
  resources :cart do
    resources :order do
      resources :review
      resources :payment

    end
  end


  # API routes
  namespace :api , default: {format: :json} do

    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)

    scope :users , module: :users do
      post '/' , to: "registrations#create",as: :user_registration
    end

    devise_for :users , controllers:{
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }

    root 'home#index'
    get 'home/index'

    # custom api
    get 'product/all_products'
    get 'order/order_history'


    resources :product do
      resources :cart, only: :new
    end

    resources :seller

    resources :customer
    resources :cart do
      resources :order do
        resources :review
        resources :payment
      end
    end

  end



  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

end