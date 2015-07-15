Rails.application.routes.draw do

  root 'tasks#index'

  get 'tasks', to: redirect('/'), as: :tasks

  resources :tasks, except: :index do
    member do
      get 'mark_as_performed', as: :mark_as_performed
    end
  end

  scope :sms_notifications do
    post 'smsru_callback', to: 'sms_notifications#smsru_callback'
  end

  devise_for :users, sign_out_via: [:get, :delete]

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  require 'sidekiq/web'
  authenticated :admin_user do
    scope "/sidekiq" do
      mount Sidekiq::Web => '/'
    end
  end
end