# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  devise_for :players, controllers: { omniauth_callbacks: 'authentication' }

  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  namespace :api, defaults: { format: :json } do
    resources :player, only: [:index]

    resources :doctrines, only: [:index, :show]

    resources :companies, only: [:index, :create, :destroy] do
      member do
        get 'available_units'
      end
    end
  end

  root "main#index"
  get '*path' => redirect('/')
end
