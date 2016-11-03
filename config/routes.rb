require 'resque/server'

Rails.application.routes.draw do
  get 'welcome/index'
  root to: 'welcome#index'

  devise_for :users

  authenticate :user do
    mount Resque::Server, at: '/jobs'
  end
end
