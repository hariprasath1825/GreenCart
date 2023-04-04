Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'payment/index'
  get 'payment/new'
  get 'payment/create'


  devise_for :users , controllers:{
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root 'home#index'

  # devise_scope :user do
  #   root 'devise/sessions#new'
  # end

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


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

end