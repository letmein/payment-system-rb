# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resources :payments, only: :create
  end

  root to: 'sessions#new'

  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy'

  namespace :admin do
    root to: 'merchants#index'
    resources :merchants, only: %i[index edit update destroy]
    resources :payments, only: :index
  end

  resources :payments, only: :index
end
