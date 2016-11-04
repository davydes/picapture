require 'resque/server'

Rails.application.routes.draw do
  get 'welcome/index'
  root to: 'welcome#index'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  namespace :users do
    resources :authentications, only: [:create, :new]
  end

  authenticate :user do
    mount Resque::Server, at: '/jobs'
  end
end
