# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users

  scope(except: :show) do
    resources :hosting_servers do
      member do
        put :setup
      end
      resources :apache_variations
      resources :smtp_settings
    end
  end

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'hosting_servers#index'
end
