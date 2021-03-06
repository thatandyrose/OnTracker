Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users

  resources :users do
    get :unapproved, on: :collection
    get :approve, on: :member
  end

  resources :tickets do
    get :open, on: :collection
    get :closed, on: :collection
    get :unassigned, on: :collection
    get 'status/:status_key', on: :collection, action: :status, as: :status
    get :search, on: :collection
    get :docs, on: :collection
    get :own, on: :member
  end

  resources :statuses

  namespace :api do
    namespace :v1 do
      resources :tickets, only: [:create]
      resources :departments, only: [:index]
    end
  end
end
