require 'resque/server'

Rails.application.routes.draw do
  get 'welcome/index'
  root to: 'welcome#index'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  namespace :api, defaults: { format: 'json' } do
    resources :photos
  end

  authenticate :user do
    mount Resque::Server, at: '/jobs'
  end
end
