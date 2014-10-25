Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users

  resources :users do
    get :unapproved, on: :collection
    get :approve, on: :member
  end

  resources :tickets do
    get :open, on: :collection
    get :own, on: :member
  end
end
