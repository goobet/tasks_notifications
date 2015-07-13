Rails.application.routes.draw do

  root 'users#profile', as: :profile

  resources :tasks do
    member do
      get 'mark_as_performed', as: :mark_as_performed
    end
  end

  devise_for :users, sign_out_via: [:get, :delete]

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end