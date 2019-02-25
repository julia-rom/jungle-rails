# frozen_string_literal: true

Rails.application.routes.draw do
  resources :reviews
  # these routes are for showing users a login form, logging them in, and logging them out.
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/signup' => 'users#new'
  post '/users' => 'users#create'

  root to: 'products#index'

  resources :products, only: %i[index show] do
    resources :reviews, only: [:create]
  end
  resources :categories, only: %i[index show]

  resource :cart, only: [:show] do
    post   :add_item
    post   :remove_item
  end

  resources :orders, only: %i[create show]

  namespace :admin do
    root to: 'dashboard#show'
    resources :categories, :products, except: %i[edit update show]
  end
end
