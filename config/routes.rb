Rails.application.routes.draw do


  # devise_for :users

  devise_for :users , controllers:{
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root 'home#index'

  # devise_scope :user do
  #   root 'devise/sessions#new'
  # end

  get 'seller/index'
  get 'home/index'
  get 'product/index'
  get 'product/showcust'

  resources :product do
    resources :cart, only: :new
  end

  resources :customer
  resources :cart do
    resources :order
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end