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

  root to: 'hosting_servers#index'
end
