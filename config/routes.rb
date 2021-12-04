# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  mount Tokenable::Engine => '/api/auth'
  devise_for :players, controllers: { omniauth_callbacks: 'authentication' }

  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  resources :player, only: [:index]

  resources :doctrines, only: [:index, :show]

  resources :companies, only: [:index, :show]

  root "main#index"
end
